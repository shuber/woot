require 'scrapi'
require 'tweetstream'

Tidy.path = ENV['TIDY_PATH'] if ENV['TIDY_PATH']

class Woot
  DOMAIN = 'woot.com'
  SELLOUT_DOMAIN = 'shopping.yahoo.com'
  WOOT_OFF = 'woot-off'
  TWITTER_IDS = {
    'kids'    => 66527200,
    'shirt'   => 7696162,
    'sellout' => 15458304,
    'wine'    => 1647621,
    'www'     => 734493,
    WOOT_OFF  => 20557892
  }
  SUBDOMAINS = TWITTER_IDS.keys - [WOOT_OFF]
  
  def self.scrape(subdomain = :www)
    url = "http://#{subdomain}.#{DOMAIN}/"
    if subdomain.to_s == 'sellout'
      url = Scraper.define do
        process_first "div.bd>div.img>a", :url => '@href'
        result :url
      end.scrape(Net::HTTP.get(SELLOUT_DOMAIN, '/')).gsub('&amp;', '&')
    end
    response = Net::HTTP.get(URI.parse(url))
    
    selectors = self.selectors(subdomain)
    Scraper.define do
      result *(selectors.inject([]) do |array, (pattern, results)|
        process_first pattern, results
        array += results.keys
      end)
    end.scrape(response)
  end
  
  def self.selectors(subdomain = :www)
    @selectors = {
      '*'                         => { :subdomain => proc { |element| subdomain.to_s } },
      'h2.fn'                     => { :title => :text },
      'span.amount'               => { :price => :text },
      'ul#shippingOptions'        => { :shipping => :text },
      'img.photo'                 => { :image => '@src' },
      'div.hproduct>a'            => { :alternate_image => proc { |element| $1 if element.attributes['href'] =~ /\('([^']+)'\);/ } },
      'a.url'                     => { :url => '@href' },
      'li.comments>a'             => { :comments_url => '@href', :comments_count => proc { |element| element.children[0].content.gsub(/\D/, '') } },
      'div.story>h2'              => { :header => :text },
      'div.story>h3'              => { :sub_header => :text },
      'div.writeUp'               => { :writeup => :text },
      'div.specs'                 => { :specs => :text },
      'div.productDescription>dl' => { :details => :text },
      'a#ctl00_ctl00_ContentPlaceHolderLeadIn_ContentPlaceHolderLeadIn_SaleControl_HyperLinkWantOne' => { :purchase_url => proc do |element|
        "http://#{subdomain}.#{DOMAIN}#{element.attributes['href'].gsub(/^https?:\/\/[^\/]+/, '')}" if element.attributes.has_key?('href')
       end }
    }
  end
  
  def self.stream(twitter_username, twitter_password)
    TweetStream::Client.new(twitter_username, twitter_password).follow(*TWITTER_IDS.values) do |status|
      subdomain = TWITTER_IDS.index(status.user.id)
      subdomain = $1 if subdomain == WOOT_OFF && subdomain =~ /https?:\/\/([^\.]+)\.#{DOMAIN}/
      yield scrape(subdomain) unless subdomain.nil?
    end
  end
  
  def self.stop
    TweetStream::Client.stop
  end
end