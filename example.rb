$dg_library_path = File.expand_path File.join File.dirname(__FILE__), 'lib'

unless $LOAD_PATH.include? $dg_library_path
  $LOAD_PATH.unshift $dg_library_path
end

require 'rubygems'
require 'pp'
require 'configfiles'
require 'dansguardian'

dg = DansGuardian::Config.new 

pp dg


