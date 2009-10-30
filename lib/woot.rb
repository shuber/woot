module Woot
  DOMAIN = 'woot.com'
  
  def self.scrape(subdomain = :www)
    host = "http://#{subdomain}.#{DOMAIN}"
    ::Scraper.define do
      result *(Scraper.selectors.inject([]) do |array, (pattern, results)|
        process pattern, results
        array += results.keys
      end)
    end.scrape(URI.parse("#{host}/"))
  end
  
  class Scraper
    def self.selector(pattern, results)
      selectors[pattern] = results
    end
    
    def self.selectors
      @selectors ||= {}
    end
    
    selector 'h2.fn', :title => :text
    selector 'span.amount', :price => :text
    selector 'ul#shippingOptions', :shipping => :text
    selector 'img.photo', :image => '@src'
    selector 'div.hproduct>a', :alternate_image => proc { |element| $1 if element.attributes['href'] =~ /\('([^']+)'\);/ }
    selector 'a.url', :url => '@href'
    selector 'a#ctl00_ctl00_ContentPlaceHolderLeadIn_ContentPlaceHolderLeadIn_SaleControl_HyperLinkWantOne', :purchase_url => '@href'
    selector 'li.comments>a', :comments_url => '@href', :comments_count => proc { |element| element.children[0].content.gsub(/\D/, '') }
    selector 'div.productDescription>dl', :details => :text
    selector 'div.story>h2', :header => :text
    selector 'div.story>h3', :sub_header => :text
    selector 'div.writeUp', :writeup => :text
    selector 'div.specs', :specs => :text
  end
end