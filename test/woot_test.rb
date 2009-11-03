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
  
end