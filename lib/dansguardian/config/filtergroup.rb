autoload :URI, 'uri'

require 'dansguardian/config/constants'

module DansGuardian
  class Config
    class FilterGroup < ::ConfigFiles::Base

      on :unknown_parameter do |s|
        "FIXME: unknown parameter: value = #{s}"  
      end

      GROUPMODE = {
        '0' => :banned,
        '1' => :filtered,
        '2' => :unfiltered
      }
      parameter :groupmode, GROUPMODE
      default 	:groupmode, :filtered
      
      parameter :groupname
      default   :groupname, ''

      [
        :bannedphraselist,
        :bannedsitelist,
        :bannedurllist,
        :bannedregexpurllist,
        :bannedextensionlist,
        :bannedregexpheaderlist,
        :bannedmimetypelist,
        :headerregexplist, # ban

        :weightedphraselist,

        :greysitelist,
        :greyurllist,

        :contentregexplist, # modify
        :urlregexplist,     # modify

        :exceptionextensionlist,
        :exceptionmimetypelist,
        :exceptionfilesitelist,
        :exceptionfileurllist,
        :exceptionphraselist,
        :exceptionsitelist,
        :exceptionurllist,
        :exceptionregexpurllist,
 
        :logsitelist,
        :logurllist,
        :logregexpurllist,

        :picsfile,

      ].each do |name|
        parameter name 
      end

      # may override the main config file
      parameter :weightedphrasemode,
        '0'   => :disabled,
        '1'   => :normal,
        '2'   => :singular
      default   :weightedphrasemode, :inherit

      parameter :naughtynesslimit, :to_i

      virtual   :naughtyness do |confdata|
        case confdata[:naughtynesslimit]
        when 0..50
          :young_children
        when 51..100
          :old_children
        when 101..150       # sure of 150 ?
          :young_adults
        when 150..INFINITY
          :adults
        end
      end

      parameter :categorydisplaythreshold do |str|
        case str
        when '-1'
          :highest_only
        when '0'
          :all
        else
          n = str.to_i
          if n > 0
            n
          else
            # 'eager' validation ;-)
            raise ValidationFailed, "found an invalid value '#{str}' for parameter :categorydisplaythreshold"
          end
        end
      end
      default   :categorydisplaythreshold,  :all

      parameter :embeddedurlweight,         :to_i
      default   :embeddedurlweight,         0

      parameter :blockdownloads,            BOOL
      default   :blockdownloads,            false

      parameter :enablepics,                BOOL
      default   :blockdownloads,            false

      [:bypass, :infectionbypass].each do |name|
        parameter name do |str|
          case str
          when '-1'
            :require_separate_program
          when '0'
            :disable
          else
            seconds = str.to_i
            if seconds > 0
              seconds
            else
              # 'eager' validation...
              raise ValidationFailed, "found an invalid value '#{str}' for parameter '#{name}'"
            end
          end
        end
        default   name, :disable
      end

      [:bypasskey, :infectionbypasskey].each do |name|
        parameter name do |str|
          case str
          when /^\s*$/
            :generate_random
          else
            str
          end
        end
        default   name, :generate_random
      end

      parameter :infectionbypasserrorsonly, BOOL
      default   :infectionbypasserrorsonly, true

      parameter :disablecontentscan,        BOOL
      default   :disablecontentscan,        false
      virtual(:contentscan) {|conf| !conf[:disablecontentscan]} 

      parameter :deepurlanalysis,           BOOL
      default   :deepurlanalysis,           false

      parameter :reportinglevel,            REPORTING_LEVEL

      parameter(:accessdeniedaddress)       {|s| URI.parse s} 

      parameter :htmltemplate

      parameter :usesmtp,                   BOOL
      default   :usesmtp,                   false

      [:mailfrom, :avadmin, :contentadmin, :avsubject, :contentsubject].each do |name|
        parameter name do |str|
          case str
          when /^\s*$/
            nil
          else
            str
          end
        end
      end

      [:notifyav, :notifycontent, :thresholdbyuser].each do |name|
        parameter name,                     BOOL
      end

      parameter :violations,                :to_i
      virtual   :violations_before_notification do |cfdata|
        case cfdata[:violations]
        when 0
          :never
        else
          cfdata[:violations]
        end
      end

      parameter :threshold,                 :to_i

    end 
  end
end


