require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'scrapi'
require 'tweetstream'
Tidy.path = ENV['TIDY_PATH'] if ENV['TIDY_PATH']

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'woot'

class Test::Unit::TestCase

  def self.attributes
    @attributes ||= Woot.selectors.map { |selector, results| results.keys }.flatten
  end
  
  def self.possible_blank_attributes
    @possible_blank_attributes ||= [:purchase_url]
  end
  
  def self.subdomains 
    @subdomains ||= [:www, :wine, :shirt, :kids] # TODO: sellout
  end
  
end