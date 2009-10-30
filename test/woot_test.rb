require 'test_helper'

def subdomains; [:www, :wine, :shirt, :kids]; end # TODO: sellout
def possible_blanks; [:purchase_url]; end
def attributes; Woot.selectors.map { |selector, results| results.keys }.flatten; end

class WootTest < Test::Unit::TestCase

  subdomains.each do |subdomain|
    context "When parsing http://#{subdomain}.#{Woot::DOMAIN}/ it" do
      setup { @woot = Woot.scrape(subdomain) }
      
      attributes.each do |attribute|
        should "have a key for #{attribute}" do
          assert @woot.members.include?(attribute.to_s)
        end
        
        unless possible_blanks.include?(attribute)
          should "have a value for #{attribute}" do
            assert !@woot.send(attribute).nil?
            assert !@woot.send(attribute).empty?
          end
        end
      end
    end
  end
  
end