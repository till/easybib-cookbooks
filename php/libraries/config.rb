module Php
  class Config
    def initialize(ext_name, directives)
      @ext_name = ext_name.downcase
      @directives = directives
    end

    # strip leading extension name in case it's included
    # this makes it a little more robust
    def get_directives
      keep = Hash.new
      l = @ext_name.length

      @directives.each do |k,v|
        if k[0, l] != @ext_name
          keep[k] = v
          next
        end

        new_key = k[(l+1)..-1]
        keep[new_key] = v
      end

      keep
    end
  end
end
