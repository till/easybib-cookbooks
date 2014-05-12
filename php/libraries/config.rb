module Php
  class Config
    def initialize(ext_name, directives)
      @ext_name = ext_name.downcase
      @directives = directives
    end

    # add leading extension name in case it's not included
    # this makes it a little more robust
    def get_directives
      keep = {}
      l = @ext_name.length

      @directives.each do |k, v|
        if k[0, l] == @ext_name
          keep[k] = v
          next
        end

        new_key = "#{@ext_name}.#{k}"
        keep[new_key] = v
      end

      keep
    end
  end
end
