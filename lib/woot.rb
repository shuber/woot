require 'rubygems'
require 'nokogiri'
require 'tweetstream'
require 'net/http'

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
  
  attr_reader :subdomain
  
  def initialize(subdomain = 'www')
    @subdomain = subdomain.to_s
  end
  
  def document
    @document ||= Nokogiri::HTML(html)
  end
  
  def html
    @html ||= Net::HTTP.get(URI.parse(scrape_url))
  end
  
  def to_h
    @to_h ||= self.class.attributes.inject({}) { |hash, attribute| hash.merge! attribute => send(attribute) }
  end
  
  def self.attribute(name, selector, result = nil, &block)
    attributes << name unless attributes.include?(name)
    instance_variable_name = "@#{name}"
    define_method name do
      instance_variable_set(instance_variable_name, parse(selector, block_given? ? block : result)) unless instance_variable_defined?(instance_variable_name)
      instance_variable_get(instance_variable_name)
    end
  end
  
  def self.attributes
    @attributes ||= [:subdomain]
  end
  
  def self.stream(twitter_username, twitter_password)
    TweetStream::Client.new(twitter_username, twitter_password).follow(*TWITTER_IDS.values) do |status|
      subdomain = subdomain_from_twitter_status(status)
      yield new(subdomain) unless subdomain.nil?
    end
  end
  
  def self.stop
    TweetStream::Client.stop
  end
  
  protected
  
    def evaluate_result(result, element)
      case result
        when Symbol
          element.send(result).to_s.strip
        when Proc
          result.bind(self).call(element)
        when String
          element.attributes[result].to_s.strip
        else
          result
        end
    end
    
    def parse(selector, result)
      evaluate_result result, document.css(selector).first
    end
    
    def scrape_url
      subdomain.to_s == 'sellout' ? Nokogiri::HTML(Net::HTTP.get(SELLOUT_DOMAIN, '/')).css('.bd .img a').first.attributes['href'] : "http://#{subdomain}.#{DOMAIN}/"
    end
    
    def self.subdomain_from_twitter_status(status)
      subdomain = TWITTER_IDS.index(status.user.id)
      subdomain = (status.text =~ /(\w+)\.#{DOMAIN}/ ? $1 : nil) if subdomain == WOOT_OFF
      subdomain
    end
    
end

class Woot
  
  attribute :alternate_image, '.hproduct a', proc { |element| $1 if element.attributes['href'].to_s =~ /\('([^']+)'\);/ }
  attribute :comments_count, '.comments a', proc { |element| element.content.gsub(/\D/, '') }
  attribute :comments_url, '.comments a', 'href'
  attribute :currency, '.currency', 'title'
  attribute :currency_symbol, '.currency', :content
  attribute :details, '.productDescription dl', :content
  attribute :header, '.story h2', :content
  attribute :image, '.photo', 'src'
  attribute :price, '.amount', :content
  attribute :purchase_url, '#ctl00_ctl00_ContentPlaceHolderLeadIn_ContentPlaceHolderLeadIn_SaleControl_HyperLinkWantOne', proc { |element| "http://#{subdomain}.#{DOMAIN}#{element.attributes['href'].to_s.gsub(/^https?:\/\/[^\/]+/, '')}" if element.attributes.has_key?('href') }
  attribute :shipping, '#shippingOptions', :content
  attribute :specs, '.specs', :content
  attribute :subheader, '.story h3', :content
  attribute :title, '.fn', :content
  attribute :url, '.url', 'href'
  attribute :writeup, '.writeUp', :content
  
end