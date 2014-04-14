# encoding: UTF-8

# $HeadURL$
# $Id$
#
# Copyright (c) 2009-2014 by Public Library of Science, a non-profit corporation
# http://www.plos.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'cgi'

class Source < ActiveRecord::Base
  # include state machine
  include Statable

  # include default methods for subclasses
  include Configurable

  # include methods for calculating metrics
  include Measurable

  # include HTTP request helpers
  include Networkable

  # include CouchDB helpers
  include Couchable

  has_many :retrieval_statuses, :dependent => :destroy
  has_many :retrieval_histories, :dependent => :destroy
  has_many :articles, :through => :retrieval_statuses
  has_many :alerts
  has_many :api_responses
  has_many :delayed_jobs, primary_key: "name", foreign_key: "queue", :dependent => :destroy
  belongs_to :group

  serialize :config, OpenStruct

  after_update :check_cache, :if => proc { |source| source.state_changed? || source.display_name_changed? }

  validates :name, :presence => true, :uniqueness => true
  validates :display_name, :presence => true
  validates :workers, :numericality => { :only_integer => true }, :inclusion => { :in => 1..20, :message => "should be between 1 and 20" }
  validates :timeout, :numericality => { :only_integer => true }, :inclusion => { :in => 1..3600, :message => "should be between 1 and 3600" }
  validates :wait_time, :numericality => { :only_integer => true }, :inclusion => { :in => 1..3600, :message => "should be between 1 and 3600" }
  validates :max_failed_queries, :numericality => { :only_integer => true }, :inclusion => { :in => 1..1000, :message => "should be between 1 and 1000" }
  validates :max_failed_query_time_interval, :numericality => { :only_integer => true }, :inclusion => { :in => 1..864000, :message => "should be between 1 and 864000" }
  validates :job_batch_size, :numericality => { :only_integer => true }, :inclusion => { :in => 1..1000, :message => "should be between 1 and 1000" }
  validates :rate_limiting, :numericality => { :only_integer => true }, :inclusion => { :in => 1..2678400, :message => "should be between 1 and 2678400" }
  validates :batch_time_interval, :numericality => { :only_integer => true }, :inclusion => { :in => 1..86400, :message => "should be between 1 and 86400" }
  validates :staleness_week, :numericality => { :greater_than => 0 }, :inclusion => { :in => 1..2678400, :message => "should be between 1 and 2678400" }
  validates :staleness_month, :numericality => { :greater_than => 0 }, :inclusion => { :in => 1..2678400, :message => "should be between 1 and 2678400" }
  validates :staleness_year, :numericality => { :greater_than => 0 }, :inclusion => { :in => 1..2678400, :message => "should be between 1 and 2678400" }
  validates :staleness_all, :numericality => { :greater_than => 0 }, :inclusion => { :in => 1..2678400, :message => "should be between 1 and 2678400" }
  validate :validate_cron_line_format, :allow_blank => true

  scope :available, where("state = ?", 0).order("group_id, sources.display_name")
  scope :installed, where("state > ?", 0).order("group_id, sources.display_name")
  scope :retired, where("state = ?", 1).order("group_id, sources.display_name")
  scope :visible, where("state > ?", 1).order("group_id, sources.display_name")
  scope :inactive, where("state = ?", 2).order("group_id, sources.display_name")
  scope :active, where("state > ?", 2).order("group_id, sources.display_name")
  scope :for_events, where("state > ?", 2).where("name != ?", 'relativemetric').order("group_id, sources.display_name")
  scope :queueable, where("state > ?", 2).where("queueable = ?", true).order("group_id, sources.display_name")

  # some sources cannot be redistributed
  scope :public_sources, lambda { where("private = ?", false) }
  scope :private_sources, lambda { where("private = ?", true) }

  INTERVAL_OPTIONS = [['½ hour', 30.minutes],
                      ['1 hour', 1.hour],
                      ['2 hours', 2.hours],
                      ['3 hours', 3.hours],
                      ['6 hours', 6.hours],
                      ['12 hours', 12.hours],
                      ['24 hours', 24.hours],
                      ['¼ month', (1.month * 0.25).to_i],
                      ['½ month', (1.month * 0.5).to_i],
                      ['1 month', 1.month],
                      ['3 months', 3.months],
                      ['6 months', 6.months],
                      ['12 months', 12.months]]

  def to_param  # overridden, use name instead of id
    name
  end

  def remove_queues
    DelayedJob.delete_all(queue: name)
    RetrievalStatus.update_all(["queued_at = ?", nil], ["source_id = ?", id])
  end

  def queue_all_articles(options = {})
    return 0 unless active?

    priority = options[:priority] || Delayed::Worker.default_priority

    # find articles that need to be updated. Not queued currently, scheduled_at doesn't matter
    rs = retrieval_statuses

    # optionally limit to articles scheduled_at in the past
    rs = rs.stale unless options[:all]

    # optionally limit by publication date
    if options[:start_date] && options[:end_date]
      rs = rs.joins(:article).where("articles.published_on" => options[:start_date]..options[:end_date])
    end

    rs = rs.order("retrieval_statuses.id").pluck("retrieval_statuses.id")
    count = queue_article_jobs(rs, priority: priority)
  end

  def queue_article_jobs(rs, options = {})
    return 0 unless active?

    if rs.length == 0
      wait
      return 0
    end

    priority = options[:priority] || Delayed::Worker.default_priority

    rs.each_slice(job_batch_size) do |rs_ids|
      Delayed::Job.enqueue SourceJob.new(rs_ids, id), queue: name, run_at: schedule_at, priority: priority
    end

    rs.length
  end

  # condition for not adding more jobs and disabling the source
  def check_for_failures
    failed_queries = Alert.where("source_id = ? and updated_at > ?", id, Time.zone.now - max_failed_query_time_interval).count
    failed_queries > max_failed_queries
  end

  def get_active_job_count
    Delayed::Job.count('id', :conditions => ["queue = ? AND locked_by IS NOT NULL", name])
  end

  def working_count
    delayed_jobs.count(:locked_at)
  end

  def check_for_available_workers
    # limit the number of workers per source
    workers >= working_count
  end

  def pending_count
    delayed_jobs.count - working_count
  end

  def get_data(article, options={})
    fail NotImplementedError, 'Children classes should override get_data method'
  end

  def get_query_url(article)
    url % { :doi => article.doi_escaped }
  end

  def get_events_url(article)
    events_url % { :doi => article.doi_escaped }
  end

  # Custom validations that are triggered in state machine
  def validate_config_fields
    config_fields.each do |field|

      # Some fields can be blank
      next if name == "crossref" && field == :password
      next if name == "mendeley" && field == :access_token
      next if name == "twitter_search" && field == :access_token

      errors.add(field, "can't be blank") if send(field).blank?
    end
  end

  # Custom validation for cron_line field
  def validate_cron_line_format
    cron_parser = CronParser.new(cron_line)
    cron_parser.next(Time.zone.now)
  rescue ArgumentError
    errors.add(:cron_line, "is not a valid crontab entry")
  end

  def check_cache
    if ActionController::Base.perform_caching
      DelayedJob.delete_all(queue: "#{name}-cache-queue")
      delay(priority: 0, queue: "#{name}-cache-queue").expire_cache
    end
  end

  # Remove all retrieval records for this source that have never been updated,
  # return true if all records are removed
  def remove_all_retrievals
    rs = retrieval_statuses.where(:retrieved_at == '1970-01-01').delete_all
    retrieval_statuses.count == 0
  end

  # Create an empty retrieval record for every article for the new source
  def create_retrievals
    article_ids = RetrievalStatus.where(:source_id => id).pluck(:article_id)

    sql = "insert into retrieval_statuses (article_id, source_id, created_at, updated_at, scheduled_at) select id, #{id}, now(), now(), now() from articles"
    sql += " where articles.id not in (#{article_ids.join(",")})" if article_ids.any?

    ActiveRecord::Base.connection.execute sql
  end

  def cache_timeout
    30.seconds + (Article.count / 250).seconds
  end

  private

  def expire_cache
    update_column(:cached_at, Time.zone.now)
    source_url = "http://localhost/api/v5/sources/#{name}?api_key=#{CONFIG[:api_key]}"
    get_json(source_url, timeout: cache_timeout)

    Rails.cache.write('status:timestamp', Time.zone.now.utc.iso8601)
    status_url = "http://localhost/api/v5/status?api_key=#{CONFIG[:api_key]}"
    get_json(status_url, timeout: cache_timeout)
  end
end
