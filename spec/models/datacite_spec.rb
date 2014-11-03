require 'rails_helper'

describe Datacite, :type => :model do
  subject { FactoryGirl.create(:datacite) }

  let(:article) { FactoryGirl.build(:article, :doi => "10.1371/journal.ppat.1000446") }

  context "get_data" do
    it "should report that there are no events if the doi is missing" do
      article = FactoryGirl.build(:article, :doi => nil)
      expect(subject.get_data(article)).to eq({})
    end

    it "should report if there are no events and event_count returned by the Datacite API" do
      article = FactoryGirl.build(:article, :doi => "10.1371/journal.pone.0043007")
      body = File.read(fixture_path + 'datacite_nil.json')
      stub = stub_request(:get, subject.get_query_url(article)).to_return(:body => body)
      response = subject.get_data(article)
      expect(response).to eq(JSON.parse(body))
      expect(stub).to have_been_requested
    end

    it "should report if there are events and event_count returned by the Datacite API" do
      body = File.read(fixture_path + 'datacite.json')
      stub = stub_request(:get, subject.get_query_url(article)).to_return(:body => body)
      response = subject.get_data(article)
      expect(response).to eq(JSON.parse(body))
      expect(stub).to have_been_requested
    end

    it "should catch timeout errors with the Datacite API" do
      stub = stub_request(:get, subject.get_query_url(article)).to_return(:status => [408])
      response = subject.get_data(article, options = { :source_id => subject.id })
      expect(response).to eq(error: "the server responded with status 408 for http://search.datacite.org/api?q=relatedIdentifier:#{article.doi_escaped}&fl=relatedIdentifier,doi,creator,title,publisher,publicationYear&fq=is_active:true&fq=has_metadata:true&indent=true&rows=100&wt=json", :status=>408)
      expect(stub).to have_been_requested
      expect(Alert.count).to eq(1)
      alert = Alert.first
      expect(alert.class_name).to eq("Net::HTTPRequestTimeOut")
      expect(alert.status).to eq(408)
      expect(alert.source_id).to eq(subject.id)
    end
  end

  context "parse_data" do
    let(:null_response) { { events: [], :events_by_day=>[], :events_by_month=>[], events_url: "http://search.datacite.org/ui?q=relatedIdentifier:#{article.doi_escaped}", event_count: 0, event_metrics: { pdf: nil, html: nil, shares: nil, groups: nil, comments: nil, likes: nil, citations: 0, total: 0 } } }

    it "should report if the doi is missing" do
      article = FactoryGirl.build(:article, :doi => nil)
      result = {}
      expect(subject.parse_data(result, article)).to eq(events: [], :events_by_day=>[], :events_by_month=>[], events_url: nil, event_count: 0, event_metrics: { pdf: nil, html: nil, shares: nil, groups: nil, comments: nil, likes: nil, citations: 0, total: 0 })
    end

    it "should report if there are no events and event_count returned by the Datacite API" do
      body = File.read(fixture_path + 'datacite_nil.json')
      result = JSON.parse(body)
      expect(subject.parse_data(result, article)).to eq(null_response)
    end

    it "should report if there are events and event_count returned by the Datacite API" do
      body = File.read(fixture_path + 'datacite.json')
      result = JSON.parse(body)
      response = subject.parse_data(result, article)
      expect(response[:event_count]).to eq(1)
      expect(response[:events_url]).to eq("http://search.datacite.org/ui?q=relatedIdentifier:#{article.doi_escaped}")
      event = response[:events].first
      expect(event[:event_url]).to eq("http://doi.org/10.5061/DRYAD.8515")
    end

    it "should catch timeout errors with the Datacite API" do
      result = { error: "the server responded with status 408 for http://search.datacite.org/api?q=relatedIdentifier:#{article.doi_escaped}&fl=relatedIdentifier,doi,creator,title,publisher,publicationYear&fq=is_active:true&fq=has_metadata:true&indent=true&rows=100&wt=json", status: 408 }
      response = subject.parse_data(result, article)
      expect(response).to eq(result)
    end
  end
end
