class Woot
  DOMAIN = 'woot.com'
  
  def self.scrape(subdomain = :www)
    selectors = self.selectors(subdomain)
    Scraper.define do
      result *(selectors.inject([]) do |array, (pattern, results)|
        process pattern, results
        array += results.keys
      end)
    end.scrape(URI.parse("http://#{subdomain}.#{DOMAIN}/"))
  end
  
  def self.selectors(subdomain = :www)
    @selectors = {
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
end