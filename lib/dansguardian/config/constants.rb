require 'configfiles'

module DansGuardian
  module Config

      # Useful constants
      INFINITY = ::Float::INFINITY

      # Recurring converters
      BOOL = {'on'  => true, 'off' => false}

      # Exceptions
      class ValidationFailed < ::ConfigFiles::Base::ValidationFailed; end

  end
end

