autoload :IPAddr, 'ipaddr'
autoload :URI,    'uri'

require 'configfiles'

module DansGuardian
  class Config < ConfigFiles::Base

    on :unknown_parameter do |s|
      "FIXME: unknown parameter: value = #{s}"  
    end

    parameter :reportinglevel, 
       '-1' => :log_only,
        '0' => :access_denied_only,
        '1' => :why_but_not_what,
        '2' => :full,
        '3' => :html_template    
    
    parameter :languagedir

    parameter :language

    parameter :loglevel, 
        '0'   => :none,
        '1'   => :just_denied,
        '2'   => :all_text_based,
        '3'   => :all_requests

    parameter :logexceptionhits,
        '0'   => :never,
        '1'   => :log,
        '2'   => :log_and_mark

    parameter :logfileformat,
        '1'   => :dansguardian,
        '2'   => :csv,
        '3'   => :squid,
        '4'   => :tabs

    parameter :maxlogitemlength, :to_i

    parameter :anonymizelogs, 'on'  => true, 'off' => false
    parameter :syslog,        'on'  => true, 'off' => false

    parameter :loglocation
    parameter :statlocation

    parameter :filterip do |str|
      if str == ''
        :any
      else
        IPAddr.new str # in case of invalid str, rely on IPAddr exceptions
      end
    end

    parameter :filterport, :to_i

    parameter :proxyip do |str| 
      IPAddr.new str
    end

    parameter :proxyport, :to_i

    parameter :accessdeniedaddress do |str|
      URI.parse str
    end

    parameter :nonstandarddelimiter,  'on'  => true, 'off' => false
    parameter :usecustombannedimage,  'on'  => true, 'off' => false

  end

  module Parser

    def self.read(io)
      h = {}
      io.each_line do |line|
        line.sub! /#.*$/, ''
        line.strip!
        case line
        when /^([^=\s]+)\s*=\s*([^=\s']*)$/ 
          h[$1.to_sym] = $2
        when /^([^=\s]+)\s*=\s*'(.*)'$/
          h[$1.to_sym] = $2.gsub(/\\'/, "'") 
        end
      end
      return h
    end

  end

end


