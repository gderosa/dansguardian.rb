$dg_library_path = File.expand_path File.join File.dirname(__FILE__), 'lib'

unless $LOAD_PATH.include? $dg_library_path
  $LOAD_PATH.unshift $dg_library_path
end

require 'rubygems'
require 'pp'
require 'configfiles'
require 'dansguardian'

file = '/etc/dansguardian/dansguardian.conf'

#dgm = DansGuardian::Config::Main.new 
#dgp = DansGuardian::Parser.read_file file
#dgm.load dgp
#pp dgm

dgconf = DansGuardian::Config.new(:mainfile => file)

dgconf.main

dgconf.filtergroup(1, :cached => true) 

listfile = dgconf.filtergroup(1)[:weightedphraselist]
listobject = DansGuardian::List.new(:file => listfile)
pp listobject

listfile2 = "/etc/dansguardian/lists/phraselists/goodphrases/weighted_news"
listobject2 = DansGuardian::List.new(listfile2)
listobject2.read!
pp listobject2








