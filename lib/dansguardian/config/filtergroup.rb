require 'dansguardian/config/constants'

module DansGuardian
  module Config
    class FilterGroup < ::ConfigFiles::Base

      on :unknown_parameter do |s|
        "FIXME: unknown parameter: value = #{s}"  
      end

      validate do |conf|
        true
      end

    end 
  end
end


