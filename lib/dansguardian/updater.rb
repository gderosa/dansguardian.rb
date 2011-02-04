module DansGuardian
  module Updater

    def self.update(io, data)
      already_written = [] 
      io.each_line do |line|
        line.strip!
        case line
        when /^([^=\s#]+)\s*=\s*([^=\s#']*)/  
          key = $1
          value = $2
        when /^([^=\s#]+)\s*=\s*'(.*)'/ 
          key = $1
          value = $2.gsub(/\\'/, "'")
        else
          yield line # commented/empty line: leave untouched
          next
        end

        # At this point, it is actually a key/value line

        next if 
            already_written.include?(key)         or 
            already_written.include?(key.to_sym)

        new_value = ( data[key] || data[key.to_sym] )
        if new_value
          if new_value.respond_to? :each # multiple values
            new_value.each do |val|
              yield "#{key} = #{val}"
            end
          else
            yield "#{key} = #{val}"
          end
          already_written << key
          # next # "optimized out"
        else # not a key/val pair to edit: leave untouched
          yield line
          # next # "optimized out"
        end
      end
    end

  end
end


