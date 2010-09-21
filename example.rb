$dg_library_path = File.expand_path File.join File.dirname(__FILE__), 'lib'

unless $LOAD_PATH.include? $dg_library_path
  $LOAD_PATH.unshift $dg_library_path
end

require 'rubygems'
require 'pp'
require 'configfiles'
require 'dansguardian'

file = '/etc/dansguardian/dansguardian.conf'
# file = '/dev/null'

dgm = DansGuardian::Config::Main.new 


dgp = DansGuardian::Parser.read_file file
dgm.load dgp
pp dgm

#dg = DansGuardian::Object.new(:mainconfigfile => '/etc/dansguardian/dansguardian.conf')

#dg.config.main

#dg.config.filtergroup(1) 

#dg.config.filtergroup(1).inclusiontree('weightedphraselist')



