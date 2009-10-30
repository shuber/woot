require 'test_helper'

class WootTest < Test::Unit::TestCase

  subdomains.each do |subdomain|
    context "When parsing http://#{subdomain}.#{Woot::DOMAIN}/ it" do
      setup { @woot = Woot.scrape(subdomain) }
      
      attributes.each do |attribute|
        should "have a key for #{attribute}" do
          assert @woot.members.include?(attribute.to_s)
        end
        
        unless possible_blank_attributes.include?(attribute)
          should "have a value for #{attribute}" do
            assert !@woot.send(attribute).nil?
            assert !@woot.send(attribute).empty?
          end
        end
      end
    end
  end
  
end