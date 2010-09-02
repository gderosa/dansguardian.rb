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
        '0' => :none,
        '1' => :just_denied,
        '2' => :all_text_based,
        '3' => :all_requests

    parameter :logexceptionhits,
        '0' => :never,
        '1' => :log,
        '2' => :log_and_mark

    parameter :logfileformat,
        '1' => :dansguardian,
        '2' => :csv,
        '3' => :squid,
        '4' => :tabs


  end
end


