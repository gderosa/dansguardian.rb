autoload :IPAddr, 'ipaddr'
autoload :URI,    'uri'
autoload :Set,    'set'

require 'configfiles'

module DansGuardian
  VERSION = '0.0.1'

  autoload :Config,     'dansguardian/config'
  autoload :Parser,     'dansguardian/parser'
  autoload :Inclusion,  'dansguardian/inclusion'
end
