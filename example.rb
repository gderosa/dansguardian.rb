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

fg1 = dgconf.filtergroup(1, :cached => true) 

listfile = dgconf.filtergroup(1)[:weightedphraselist]
listobject = DansGuardian::List.new(:file => listfile)
pp listobject

listfile2 = "/etc/dansguardian/lists/phraselists/pornography/weighted_russian"
listobject2 = DansGuardian::List.new(
  :file           => listfile2,
  :file_encoding  => Encoding.find('ISO-8859-5')
)
listobject2.read!
pp listobject2








