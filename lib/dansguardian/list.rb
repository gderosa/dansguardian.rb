module DansGuardian
  # this class does not inherit from ConfigFiles::Base
  class List

    attr_reader :items, :includes, :listcategory

    #   DansGuardian::List.new(:file = '/path/to/list')
    def initialize(h={})
      if h.is_a? String
        @init           = {:file => h}
        @file_encoding  = Encoding::BINARY
      else
        @init           = h      
      end
      @items          = []
      @includes       = []
      @listcategory   = nil
      #read! if @init[:file] 
    end

    def filename; @init[:file]; end
    def file_encoding; @init[:file_encoding]; end

    # Reads the file and fill @items ad @includes . 
    # This method might be overridden for non-trivial list types (?)
    def read!
      File.foreach(@init[:file]) do |line|
        line.force_encoding file_encoding
        line.strip!
        # Special comment used to "categorize" DG message pages
        if line =~ /^#listcategory:\s*"(.*)"/ 
          @listcategory = $1
          next
        end
        next if line =~ /^\s*#/
        line.sub! /\s#.*$/, '' # remove comments but allow http://url#anchor 
        if    line =~ /^\.Include<(.*)>/
          @includes << $1
        elsif line =~ /\S/
          @items << line.strip
        end
      end
    end

  end
end
