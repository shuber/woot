require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'scrapi'
Tidy.path = ENV['TIDY_PATH'] if ENV['TIDY_PATH']

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'woot'

class Test::Unit::TestCase
end