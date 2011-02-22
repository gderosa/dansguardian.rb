require 'dansguardian/config/constants'

module DansGuardian
  class Config
    module Auth
      # Handle SQL Auth plugin by G. De Rosa
      # http://dev.vemarsas.it/projects/dansguardian
      class SQL < ::ConfigFiles::Base

        # Exceptions
        class ValidationFailed < ValidationFailed; end

        on :unknown_parameter do |s|
          "FIXME: unknown parameter: value = #{s}"  
        end

        parameter   :plugname

        parameter   :sqlauthgroups

        parameter   :sqlauthdb 
        parameter   :sqlauthdbhost 
        parameter   :sqlauthdbname
        parameter   :sqlauthdbuser
        parameter   :sqlauthdbpass 

        parameter   :sqlauthipuserquery
        parameter   :sqlauthusergroupquery
        
        parameter   :sqlauthcachettl

        parameter   :sqlauthdebug,
          'on'        => true,
          'off'       => false
        
        validate do |conf|
          raise ValidationFailed, 
              "Cannot find plugname='sqlauth' in config file" unless
              conf[:plugname] == 'sqlauth'
        end

      end
    end 
  end
end


