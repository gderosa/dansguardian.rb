require 'configfiles'

module DansGuardian
  class Config

      # Useful constants
      INFINITY = ::Float::INFINITY

      # Recurring converters
      BOOL = {
        'on'  => true, 
        'off' => false
      }
      REPORTING_LEVEL = {
       '-1'   =>    :log_only,
        '0'   =>    :access_denied_only,
        '1'   =>    :why_but_not_what,
        '2'   =>    :full,
        '3'   =>    :html_template        
      }

      # Exceptions
      class ValidationFailed < ::ConfigFiles::Base::ValidationFailed; end

  end
end

