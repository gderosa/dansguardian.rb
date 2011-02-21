require 'dansguardian/config/main'
require 'dansguardian/config/filtergroup'

module DansGuardian
  class Config

    autoload :Auth, 'dansguardian/config/auth'

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
      @mainconfig = nil
      @filtergroups = []
    end

    # get data from the main configuration file
    def main(opt_h={:cached => false})
      if opt_h[:cached]
        if @mainconfig
          return @mainconfig
        else
          get_main
        end
      else
        get_main
      end
    end

    # get filtergroup configuration data
    def filtergroup(n=1, opt_h={:cached => true})
      if opt_h[:cached]
        if @filtergroups[n]
          return @filtergroups[n]
        else
          get_filtergroup n
        end
      else
        get_filtergroup n
      end
    end

    def filtergroupfile(n=1)
      File.join File.dirname(@mainfile), "dansguardianf#{n}.conf"
    end

    protected
    
    def get_main
      dgmain = DansGuardian::Config::Main.new
      parsedata = DansGuardian::Parser.read_file @mainfile
      @mainconfig = dgmain.load parsedata
    end

    def get_filtergroup(n)
      dgf = DansGuardian::Config::FilterGroup.new
      parsedata = DansGuardian::Parser.read_file filtergroupfile(n)
      @filtergroups[n] = dgf.load parsedata
    end

  end
end
