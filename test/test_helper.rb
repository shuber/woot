require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'scrapi'
Tidy.path = '/usr/lib/libtidy.dylib'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'woot'

class Test::Unit::TestCase
end