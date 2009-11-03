require 'test_helper'

class WootTest < Test::Unit::TestCase
  
  woots.each do |subdomain, woot|
    context "When parsing http://#{subdomain}.#{Woot::DOMAIN}/ it" do
      attributes.each do |attribute|
        should "have a key for #{attribute}" do
          assert woot.members.include?(attribute.to_s)
        end
        
        unless possible_blank_attributes.include?(attribute)
          should "have a value for #{attribute}" do
            assert !woot.send(attribute).nil?
            assert !woot.send(attribute).empty?
          end
        end
      end
    end
  end
  
  context 'When parsing the fixture' do
    fixtures.each do |subdomain, file|
      context "for http://#{subdomain}.#{Woot::DOMAIN} it" do
        attributes.each do |attribute|
          should "parse the correct value for #{attribute}" do
            assert_equal WOOT_FIXTURE_VALUES[subdomain][attribute], self.class.woots[subdomain].send(attribute)
          end
        end
      end
    end
  end
  
  context 'When calling the subdomain_from_twitter_status method it' do
    should 'return nil if the user id is not included in Woot::SUBDOMAINS' do
      # Sometimes the Twitter stream may return @woot replies from other users which we don't need
      assert_nil Woot.send(:subdomain_from_twitter_status, MockTwitterStatus.new(99999999))
    end
    
    should 'return the associated subdomain if the user id is included in Woot::SUBDOMAINS' do
      Woot::SUBDOMAINS.reject { |subdomain| subdomain == Woot::WOOT_OFF }.each do |subdomain|
        assert_equal subdomain, Woot.send(:subdomain_from_twitter_status, MockTwitterStatus.new(Woot::TWITTER_IDS[subdomain]))
      end
    end
    
    should 'return the associated subdomain from the url in the status if it comes from the woot-off user' do
      assert_equal 'www', Woot.send(:subdomain_from_twitter_status, MockTwitterStatus.new(Woot::TWITTER_IDS[Woot::WOOT_OFF], "blah blah blah http://www.#{Woot::DOMAIN}"))
      assert_equal 'shirt', Woot.send(:subdomain_from_twitter_status, MockTwitterStatus.new(Woot::TWITTER_IDS[Woot::WOOT_OFF], "blah blah blah shirt.#{Woot::DOMAIN} blah blah"))
    end
    
    should 'return nil if the status comes from the woot-off user without a woot url in it' do
      assert_nil Woot.send(:subdomain_from_twitter_status, MockTwitterStatus.new(Woot::TWITTER_IDS[Woot::WOOT_OFF], 'blah blah blah'))
    end
  end
  
end