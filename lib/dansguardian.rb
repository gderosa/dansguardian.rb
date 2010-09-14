autoload :IPAddr, 'ipaddr'
autoload :URI,    'uri'
autoload :Set,    'set'

require 'configfiles'

require 'dansguardian/extensions/float'

module DansGuardian
  class Config < ::ConfigFiles::Base

    # Useful constants
    INFINITY = ::Float::INFINITY

    # Recurring converters
    BOOL = {'on'  => true, 'off' => false} 

    # Exceptions
    class ValidationFailed < ValidationFailed; end

    on :unknown_parameter do |s|
      "FIXME: unknown parameter: value = #{s}"  
    end

    parameter   :reportinglevel, 
     '-1'   =>    :log_only,
      '0'   =>    :access_denied_only,
      '1'   =>    :why_but_not_what,
      '2'   =>    :full,
      '3'   =>    :html_template    

    parameter   :languagedir

    parameter   :language

    parameter   :loglevel, 
      '0'   =>    :none,
      '1'   =>    :just_denied,
      '2'   =>    :all_text_based,
      '3'   =>    :all_requests

    parameter   :logexceptionhits,
      '0'   =>    :never,
      '1'   =>    :log,
      '2'   =>    :log_and_mark
    default     :logexceptionhits,            :log_and_mark
    
    parameter   :logfileformat,
      '1'   =>    :dansguardian,
      '2'   =>    :csv,
      '3'   =>    :squid,
      '4'   =>    :tabs
    
    parameter   :maxlogitemlength,            :to_i
    
    parameter   :anonymizelogs,               BOOL
    
    parameter   :syslog,                      BOOL
    
    parameter   :loglocation
    
    parameter   :statlocation
    
    parameter   :filterip do |str|
      if str == ''
        :any
      else
        IPAddr.new str # in case of invalid str, rely on IPAddr exceptions
      end
    end
    
    parameter   :filterport,                  :to_i
    
    parameter   :proxyip do |str| 
      IPAddr.new str
    end
    default     :proxyip,                     IPAddr.new('127.0.0.1')
    
    parameter   :proxyport,                   :to_i
    
    parameter   :accessdeniedaddress do |str|
      URI.parse str
    end
    
    parameter   :nonstandarddelimiter,        BOOL
    default     :nonstandarddelimiter,        true
    
    parameter   :usecustombannedimage,        BOOL
    default     :usecustombannedimage,        true
    
    parameter   :custombannedimagefile
    
    parameter   :filtergroups,                :to_i
    
    parameter   :filtergroupslist
    
    parameter   :bannediplist
    
    parameter   :exceptioniplist
    
    parameter   :showweightedfound,           BOOL
    
    parameter   :weightedphrasemode,
      '0'   => false,
      '1'   => :normal,
      '2'   => :singular
    
    parameter   :urlcachenumber,              :to_i
    
    parameter   :urlcacheage,                 :to_i 
        # seconds, TODO: class Time::Interval ?
    
    parameter   :scancleancache,              BOOL
    default     :scancleancache,              true
    
    parameter   :phrasefiltermode,
      '0'   =>  Set.new([:meta,  :title,         :raw]),
      '1'   =>  Set.new([:meta,  :title, :smart      ]),
      '2'   =>  Set.new([:meta,  :title, :smart, :raw]),
      '3'   =>  Set.new([:meta,  :title              ])
    default     :phrasefiltermode,  
                Set.new([:meta,  :title, :smart, :raw])
    
    parameter   :preservecase,
      '0'   =>  Set.new([:lower             ]),
      '1'   =>  Set.new([         :original ]),
      '2'   =>  Set.new([:lower,  :original ]) 
    default     :preservecase, 
                Set.new([:lower             ])
    
    parameter   :hexdecodecontent,            BOOL
    default     :hexdecodecontent,            false
    
    parameter   :forcequicksearch,            BOOL
    default     :forcequicksearch,            false

    parameter   :reverseaddresslookups,       BOOL

    parameter   :reverseclientiplookups,      BOOL

    parameter   :logclienthostnames,          BOOL

    parameter   :createlistcachefiles,        BOOL

    parameter   :maxuploadsize do |str|
      case str
      when '-1'
        INFINITY
      else
        str.to_i * 1024
      end
    end

    parameter   :maxcontentfiltersize do |str|
      case str
      when '0'
        lambda {|confdata| confdata[:maxcontentramcachescansize]} 
      else
        str.to_i * 1024
      end
    end

    parameter   :maxcontentramcachescansize do |str|
      case str
      when '0'
        lambda {|confdata| confdata[:maxcontentfilecachescansize]}
      else
        str.to_i * 1024
      end
    end

    parameter   :maxcontentfilecachescansize do |str| 
      str.to_i * 1024
    end

    parameter   :filecachedir

    parameter   :deletedownloadedtempfiles,   BOOL
    default     :deletedownloadedtempfiles,   true

    parameter   :initialtrickledelay,         :to_i

    parameter   :trickledelay,                :to_i

    # You don't really need to lazy-evaluate (short) Arrays
    #
    parameter   :downloadmanager              # Array    
    parameter   :contentscanner               # Array
    parameter   :authplugin                   # Array

    parameter   :contentscannertimeout,       :to_i
    default     :contentscannertimeout,       60

    parameter   :contentscanexceptions,       BOOL
    default     :contentscanexceptions,       false

    parameter   :recheckreplacedurls,         BOOL
    default     :recheckreplacedurls,         false

    [
      :forwardedfor, 
      :usexforwardedfor, 
      :logconnectionhandlingerrors
    ].each do |par|
      parameter par,                          BOOL
    end

    parameter   :logchildprocesshandling,     BOOL

    [
      :maxchildren, 
      :minchildren, 
      :minsparechildren, 
      :preforkchildren, 
      :maxsparechildren, 
      :maxagechildren
    ].each do |par|
      parameter par,                          :to_i
    end

    parameter   :maxips do |str|
      if str == '0'
        INFINITY
      else
        str.to_i
      end
    end

    [:ipcfilename, :urlipcfilename, :ipipcfilename, :pidfilename].each do |p|
      parameter p
    end
    default     :pidfilename,                 '/var/run/dansguardian.pid'

    [:nodaemon, :nologger, :logadblocks, :loguseragent].each do |p|
      parameter p,                            BOOL
      default   p,                            false
    end

    # TODO: implement ConfigFileas::Base.virtual
    parameter :daemon do |str|
      fail 'virtual parameter !!'
    end
    default :daemon, lambda{|confdata| !confdata[:nodaemon]}  

    validate do |d|
      raise ValidationFailed, "maxcontentfiltersize must be not higher than maxcontentramcachescansize" unless
          d[:maxcontentfiltersize] <= d[:maxcontentramcachescansize]
      raise ValidationFailed, "maxcontentramcachescansize must be not higher than maxcontentfilecachescansize" unless
          d[:maxcontentramcachescansize] <= d[:maxcontentfilecachescansize]
      raise ValidationFailed, "maxcontentfilecachescansize must be greater or equal to maxcontentramcachescansize" unless
          d[:maxcontentfilecachescansize] >= d[:maxcontentramcachescansize]
    end
   
  end

  module Parser

    def self.read(io)
      h = {}
      may_appear_multiple_times = [
        :downloadmanager, :contentscanner, :authplugin]
      io.each_line do |line|
        line.sub! /#.*$/, ''
        line.strip!
        match = false
        case line
        when /^([^=\s]+)\s*=\s*([^=\s']*)$/ 
          key = $1.to_sym
          value = $2
          match = true
        when /^([^=\s]+)\s*=\s*'(.*)'$/
          key = $1.to_sym
          value = $2.gsub(/\\'/, "'")
          match = true
        end
        if match
          if may_appear_multiple_times.include? key 
            h[key] ||= []
            h[key] << value
          else
            h[key] = value
          end
        end
      end
      return h
    end

  end

end


