module DansGuardian
  module Inclusion
    # no distinction between text parser and ConfigFile conversion here ...
    def self.get(filename)
      all = {}
      File.foreach filename do |line|
        if line =~ /^\s*\.Include\s*<(.*)>/
          all[$1] = {:active => true}
        elsif line =~ /^\s*#+\s*\.Include\s*<(.*)>/
          all[$1] = {:active => false}
        end
      end
      return all
    end
  end
end
