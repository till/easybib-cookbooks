require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

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

      return keep if @directives.nil?
      return keep if @directives.empty?

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

    def get_extension_dir(prefix)
      @extension_dir ||= begin
        p = shell_out("#{prefix}/bin/php-config --extension-dir")
        p.stdout.strip
      end
    end

    def get_extension_files
      files = []

      p = shell_out("pecl list-files #{@ext_name}")
      p.stdout.each_line.grep(/^src\s+.*\.so$/i).each do |line|
        files << line.split[1]
      end

      files
    end
  end
end
