require 'dansguardian/config/main'
require 'dansguardian/config/filtergroup'

module DansGuardian
  class Config
    # +arg+ May be +String+-like (the main config file name) or +Hash+-like :
    #
    #   DansGuardian::Config.new('path/to/dansguardian.conf')
    #
    #   DansGuardian::Config.new(:mainfile => '/path/to/dansguardian.conf')
    #
    def initialize(arg='/etc/dansguardian/dansguardian.conf')
      h = {}
      if arg.respond_to? :[]
        h = arg
      else # String-like assumed
        h = {:mainfile => arg}
      end
      @mainfile = h[:mainfile] 
    end
  end
end
