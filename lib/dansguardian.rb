autoload :IPAddr, 'ipaddr'
autoload :URI,    'uri'
autoload :Set,    'set'

require 'configfiles'

module DansGuardian
  VERSION = '0.0.2'

  autoload :Config,     'dansguardian/config'
  autoload :Parser,     'dansguardian/parser'
  autoload :Updater,    'dansguardian/updater'
  autoload :Inclusion,  'dansguardian/inclusion'
end
