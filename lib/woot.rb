class Woot
  DOMAIN = 'woot.com'
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
    selectors = self.selectors(subdomain)
    Scraper.define do
      result *(selectors.inject([]) do |array, (pattern, results)|
        process_first pattern, results
        array += results.keys
      end)
    end.scrape(URI.parse("http://#{subdomain}.#{DOMAIN}/"))
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
      unless subdomain.nil?
        subdomain = status.text.match(/https?:\/\/([^\.]+)\.#{DOMAIN}/).captures.first if subdomain == WOOT_OFF
        yield Woot.scrape(subdomain)
      end
    end
  end
  
  def self.stop
    TweetStream::Client.stop
  end
end