autoload :Tempfile,   'tempfile'
autoload :FileUtils,  'fileutils'

module DansGuardian
  module Updater

    # Update the configuration file +file+ with the +data+ Hash,
    # preserving the origin file layout, including comments.
    # The spacial value +:remove!+ comments out the 'key = ...' line.
    def self.update!(file, data)
      tmp = Tempfile.new 'ruby_dansguardian_updater'
      update file, data do |line|
        tmp.puts line
      end
      tmp.close
      FileUtils.cp tmp.path, file
      tmp.unlink
    end

    # Like update! but also accept IO objects and yields updated lines
    # instead of actually writing to a file.
    def self.update(io_or_file, data)
      if io_or_file.is_a? IO
        io = io_or_file
      else
        io = File.open io_or_file
      end

      already_written = [] 
      io.each_line do |line|
        line.strip!
        case line
        # even replace commented lines
        when /^(#\s*)?([^=\s#]+)\s*=\s*([^=\s#']*)/  
          key = $2
          value = $3
        when /^(#\s*)?[\s#]*([^=\s#]+)\s*=\s*'(.*)'/ 
          key = $2
          value = $3.gsub(/\\'/, "'")
        else
          yield line # not a key/val line: leave untouched
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
            if new_value == :remove!
              yield "# #{line}" 
            else
              yield "#{key} = #{new_value}"
            end
          end
          already_written << key
          # next # "optimized out"
        else # not a key/val pair to edit: leave untouched
          yield line
          # next # "optimized out"
        end
      end

      to_be_written = 
          data.keys.map{|k| k.to_sym} - already_written.map{|k| k.to_sym}
      to_be_written.select!{|k| data[k.to_s] || data[k.to_sym]} # reject nil values
      to_be_written.reject! do |k|
        (data[k.to_s] || data[k.to_sym]) == :remove!
      end
      if to_be_written.length > 0
        to_be_written.each do |k|
          v = data[k] || data[k.to_s]
          if v.respond_to? :each
            v.each do |val|
              yield "#{k} = #{val}"  
            end
          else
            yield "#{k} = #{v}" 
          end
        end
      end

      io.close unless io_or_file.is_a? IO
    end

  end
end


