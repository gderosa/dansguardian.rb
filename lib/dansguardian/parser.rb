module DansGuardian
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

    def self.read_file(filepath)
      File.open filepath, 'r' do |f|
        read f
      end
    end

  end
end


