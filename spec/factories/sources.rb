FactoryGirl.define do

  factory :group do
    name 'saved'
    title 'Saved'

    initialize_with { Group.where(name: name).first_or_initialize }
  end

  factory :citeulike, aliases: [:source], class: Citeulike do
    type "Citeulike"
    name "citeulike"
    title "CiteULike"
    state_event "activate"

    cached_at { Time.zone.now - 10.minutes }

    group

    initialize_with { Citeulike.where(name: name).first_or_initialize }

    factory :source_with_api_responses do
      after(:create) do |source|
        FactoryGirl.create_list(:api_response, 5, source: source, created_at: Time.zone.now - 1.hour)
      end
    end
  end

  factory :copernicus, class: Copernicus do
    type "Copernicus"
    name "copernicus"
    title "Copernicus"
    state_event "activate"
    url_private "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:%{doi}"
    username "EXAMPLE"
    password "EXAMPLE"

    group

    initialize_with { Copernicus.where(name: name).first_or_initialize }
  end

  factory :crossref, class: CrossRef do
    type "CrossRef"
    name "crossref"
    title "CrossRef"
    state_event "activate"
    openurl_username "openurl_username"

    group

    after(:create) do |source|
      FactoryGirl.create(:publisher_option, source: source)
    end

    factory :crossref_without_password do
      after(:create) do |source|
        FactoryGirl.create(:publisher_option, source: source, password: nil)
      end
    end

    initialize_with { CrossRef.where(name: name).first_or_initialize }
  end

  factory :nature, class: Nature do
    type "Nature"
    name "nature"
    title "Nature"
    state_event "activate"

    group

    initialize_with { Nature.where(name: name).first_or_initialize }
  end

  factory :github, class: Github do
    type "Github"
    name "github"
    title "Github"
    personal_access_token "EXAMPLE"

    group

    initialize_with { Github.where(name: name).first_or_initialize }
  end

  factory :bitbucket, class: Bitbucket do
    type "Bitbucket"
    name "bitbucket"
    title "Bitbucket"

    group

    initialize_with { Bitbucket.where(name: name).first_or_initialize }
  end

  factory :openedition, class: Openedition do
    type "Openedition"
    name "openedition"
    title "OpenEdition"
    state_event "activate"

    group

    initialize_with { Openedition.where(name: name).first_or_initialize }
  end

  factory :pmc, class: Pmc do
    type "Pmc"
    name "pmc"
    title "PubMed Central Usage Stats"
    state_event "activate"
    url_db "http://127.0.0.1:5984/pmc_usage_stats_test/"

    group

    after(:create) do |source|
      FactoryGirl.create(:publisher_option_for_pmc, source: source)
    end

    initialize_with { Pmc.where(name: name).first_or_initialize }
  end

  factory :pub_med, class: PubMed do
    type "PubMed"
    name "pub_med"
    title "PubMed"
    state_event "activate"

    group

    initialize_with { PubMed.where(name: name).first_or_initialize }
  end

  factory :europe_pmc, class: EuropePmc do
    type "EuropePmc"
    name "pmc_europe"
    title "PMC Europe Citations"
    state_event "activate"

    group

    initialize_with { EuropePmc.where(name: name).first_or_initialize }
  end

  factory :europe_pmc_data, class: EuropePmcData do
    type "EuropePmcData"
    name "pmc_europe_data"
    title "PMC Europe Database Citations"
    state_event "activate"

    group

    initialize_with { EuropePmcData.where(name: name).first_or_initialize }
  end

  factory :europe_pmc_fulltext, class: EuropePmcFulltext do
    type "EuropePmcFulltext"
    name "europe_pmc_fulltext"
    title "Europe PMC Fulltext Search"
    state_event "activate"

    group

    initialize_with { EuropePmcFulltext.where(name: name).first_or_initialize }
  end

  factory :nature_opensearch, class: NatureOpensearch do
    type "NatureOpensearch"
    name "nature_opensearch"
    title "Nature.com OpenSearch"
    state_event "activate"

    group

    initialize_with { NatureOpensearch.where(name: name).first_or_initialize }
  end

  factory :researchblogging, class: Researchblogging do
    type "Researchblogging"
    name "researchblogging"
    title "Research Blogging"
    state_event "activate"
    username "EXAMPLE"
    password "EXAMPLE"

    group

    initialize_with { Researchblogging.where(name: name).first_or_initialize }
  end

  factory :science_seeker, class: ScienceSeeker do
    type "ScienceSeeker"
    name "scienceseeker"
    title "ScienceSeeker"
    state_event "activate"

    group

    initialize_with { ScienceSeeker.where(name: name).first_or_initialize }
  end

  factory :datacite, class: Datacite do
    type "Datacite"
    name "datacite"
    title "DataCite"
    state_event "activate"

    group

    initialize_with { Datacite.where(name: name).first_or_initialize }
  end

  factory :datacite_data, class: Datacite do
    type "DataciteData"
    name "datacite_data"
    title "DataCite Data"
    state_event "activate"

    group

    initialize_with { DataciteData.where(name: name).first_or_initialize }
  end

  factory :wordpress, class: Wordpress do
    type "Wordpress"
    name "wordpress"
    title "Wordpress.com"
    state_event "activate"

    group

    initialize_with { Wordpress.where(name: name).first_or_initialize }
  end

  factory :reddit, class: Reddit do
    type "Reddit"
    name "reddit"
    title "Reddit"
    state_event "activate"

    group

    initialize_with { Reddit.where(name: name).first_or_initialize }
  end

  factory :twitter_search, class: TwitterSearch do
    type "TwitterSearch"
    name "twitter_search"
    title "Twitter"
    state_event "activate"
    api_key "EXAMPLE"
    api_secret "EXAMPLE"
    access_token "EXAMPLE"

    group

    initialize_with { TwitterSearch.where(name: name).first_or_initialize }
  end

  factory :wikipedia, class: Wikipedia do
    type "Wikipedia"
    name "wikipedia"
    title "Wikipedia"
    state_event "activate"
    languages "en"

    group

    initialize_with { Wikipedia.where(name: name).first_or_initialize }
  end

  factory :mendeley, class: Mendeley do
    type "Mendeley"
    name "mendeley"
    title "Mendeley"
    state_event "activate"
    client_id "EXAMPLE"
    client_secret "EXAMPLE"
    access_token "EXAMPLE"
    expires_at { Time.zone.now + 1.hour }

    group

    initialize_with { Mendeley.where(name: name).first_or_initialize }
  end

  factory :facebook, class: Facebook do
    type "Facebook"
    name "facebook"
    title "Facebook"
    client_id "EXAMPLE"
    client_secret "EXAMPLE"
    access_token "EXAMPLE"

    group

    initialize_with { Facebook.where(name: name).first_or_initialize }
  end

  factory :scopus, class: Scopus do
    type "Scopus"
    name "scopus"
    title "Scopus"
    api_key "EXAMPLE"
    insttoken "EXAMPLE"

    group

    initialize_with { Scopus.where(name: name).first_or_initialize }
  end

  factory :counter, class: Counter do
    type "Counter"
    name "counter"
    title "Counter"
    state_event "activate"
    url_private "http://www.plosreports.org/services/rest?method=usage.stats&doi=%{doi}"

    group

    initialize_with { Counter.where(name: name).first_or_initialize }
  end

  factory :dataone_counter, class: DataoneCounter do
    type "DataoneCounter"
    name "dataone_counter"
    title "DataONE Counter"
    state_event "activate"

    group

    initialize_with { DataoneCounter.where(name: name).first_or_initialize }
  end

  factory :dataone_usage, class: DataoneUsage do
    type "DataoneUsage"
    name "dataone_usage"
    title "DataONE Usage"
    state_event "activate"

    group

    initialize_with { DataoneUsage.where(name: name).first_or_initialize }
  end

  factory :f1000, class: F1000 do
    type "F1000"
    name "f1000"
    title "F1000Prime"
    state_event "activate"
    url_db "http://127.0.0.1:5984/f1000_test/"
    url_feed "http://example.org/example.xml"

    group

    initialize_with { F1000.where(name: name).first_or_initialize }
  end

  factory :figshare, class: Figshare do
    type "Figshare"
    name "figshare"
    title "Figshare"
    state_event "activate"
    url_private "http://api.figshare.com/v1/publishers/search_for?doi=%{doi}"

    group

    initialize_with { Figshare.where(name: name).first_or_initialize }
  end

  factory :plos_comments, class: PlosComments do
    type "PlosComments"
    name "plos_comments"
    title "PLOS Comments"
    state_event "activate"
    url_private "http://api.plosjournals.org/v1/articles/%{doi}?comments="

    group

    initialize_with { PlosComments.where(name: name).first_or_initialize }
  end

  factory :plos_fulltext, class: PlosFulltext do
    type "PlosFulltext"
    name "plos_fulltext"
    title "PLOS Fulltext Search"
    state_event "activate"

    group

    initialize_with { PlosFulltext.where(name: name).first_or_initialize }
  end

  factory :ads, class: Ads do
    type "Ads"
    name "ads"
    title "ADS"
    state_event "activate"
    access_token "EXAMPLE"

    group

    initialize_with { Ads.where(name: name).first_or_initialize }
  end

  factory :ads_fulltext, class: AdsFulltext do
    type "AdsFulltext"
    name "ads_fulltext"
    title "ADS Fulltext"
    state_event "activate"
    access_token "EXAMPLE"

    group

    initialize_with { AdsFulltext.where(name: name).first_or_initialize }
  end

  factory :bmc_fulltext, class: BmcFulltext do
    type "BmcFulltext"
    name "bmc_fulltext"
    title "BMC Fulltext Search"
    state_event "activate"

    group

    initialize_with { BmcFulltext.where(name: name).first_or_initialize }
  end

  factory :twitter, class: Twitter do
    type "Twitter"
    name "twitter"
    title "Twitter"
    state_event "activate"
    url_private "http://example.org?doi=%{doi}"

    group

    initialize_with { Twitter.where(name: name).first_or_initialize }
  end

  factory :wos, class: Wos do
    type "Wos"
    name "wos"
    title "Web of Science"
    state_event "activate"
    private true
    url_private "https://ws.isiknowledge.com:80/cps/xrpc"

    group

    initialize_with { Wos.where(name: name).first_or_initialize }
  end

  factory :relative_metric, class: RelativeMetric do
    type "RelativeMetric"
    name "relative_metric"
    title "Relative Metric"
    state_event "activate"
    url_private "http://example.org?doi=%{doi}"

    group

    initialize_with { RelativeMetric.where(name: name).first_or_initialize }
  end

  factory :article_coverage, class: ArticleCoverage do
    type "ArticleCoverage"
    name "article_coverage"
    title "Article Coverage"
    state_event "activate"
    url_private "http://mediacuration.plos.org/api/v1?doi=%{doi}&state=all"

    group

    initialize_with { ArticleCoverage.where(name: name).first_or_initialize }
  end

  factory :article_coverage_curated, class: ArticleCoverageCurated do
    type "ArticleCoverageCurated"
    name "article_coverage_curated"
    title "Article Coverage Curated"
    state_event "activate"
    url_private "http://mediacuration.plos.org/api/v1?doi=%{doi}"

    group

    initialize_with { ArticleCoverageCurated.where(name: name).first_or_initialize }
  end

  factory :orcid, class: Orcid do
    type "Orcid"
    name "orcid"
    title "ORCID"
    state_event "activate"

    group

    initialize_with { Orcid.where(name: name).first_or_initialize }
  end
end
