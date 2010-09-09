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

dg = DansGuardian::Config.new 

dgp = DansGuardian::Parser.read File.open file

dg.load dgp

new_h = {}

dg.data.each_pair do |k, v|
  if v.is_a? Proc
     new_h[k] = v.call(dg.data)
  end
end

p new_h

