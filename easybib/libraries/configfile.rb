module EasyBib
  class ConfigFile
    # converts hash in a string, formatted as envvars, php, ini
    def to_configformat(format, data)
      raise 'No Config supplied' if data.nil?
      config = generate_start(format)
      data.each_pair do |main_section, section_data|
        Chef::Log.info("Config: Processing section #{main_section}")
        config << generate_section_start(format, main_section)
        config << generate_config_part(format, main_section, section_data)
        config << generate_section_end(format, main_section)
      end
      config << generate_end(format)
    end

    protected

    # generate top of file
    def generate_start(format)
      case format
      when 'php'
        "<?php\nreturn [\n"
      else
        ''
      end
    end

    # generate end of file
    def generate_end(format)
      case format
      when 'php'
        '];'
      else
        ''
      end
    end

    # generates the section header
    def generate_section_start(format, main_section)
      case format
      when 'php'
        "  '#{main_section}' => [\n"
      when 'ini'
        "[#{main_section}]\n"
      else
        ''
      end
    end

    # generates the section footer
    def generate_section_end(format, main_section)
      case format
      when 'php'
        "  ],\n"
      else
        ''
      end
    end

    def generate_config_part(format, section, section_data)
      config = ''
      section_data.each_pair do |config_key, config_value|
        config_value = '' if config_value.nil?
        unless config_value.is_a?(String) || config_value.is_a?(Array)
          raise "section_data for #{config_key} is not a string or an array!"
        end
        config << build_config(format, config_key, config_value, section)
      end
      config
    end

    def build_config(format, var, value, section = nil)
      validate_value(value)

      case format
      when 'nginx'
        build_nginx_config(var, value, section)
      when 'shell'
        build_shell_config(var, value, section)
      when 'sh'
        build_shell_config(var, value, section)
      when 'ini'
        build_ini_config(var, value, section)
      when 'php'
        build_php_config(var, value, section)
      else
        raise "Unknown configuration type: #{format}."
      end
    end

    # rubocop:disable Style/GuardClause
    def validate_value(value)
      if value.is_a?(String)
        raise 'The character " is not supported as a value in the config' if  value =~ /"/
        raise "The character ' is not supported as a value in the config" if value =~ /'/
      end
    end
    # rubocop:enable Style/GuardClause

    def get_output(data, format)
      config = ''
      data.each_pair do |config_key, config_value|
        config << build_config(format, config_key, config_value)
        next
      end
      config
    end

    private

    def build_php_config(key, value, section = nil)
      if value.is_a?(Array)
        value = value.join("', '")
        return "    '#{key}'=> ['#{value}'],\n"
      end
      "    '#{key}'=>'#{value}',\n"
    end

    def build_shell_config(key, value, section = nil)
      key = format('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "export #{sub_key}=\"#{item}\"\n"
        end
        return returnvalue
      end
      "export #{key}=\"#{value}\"\n"
    end

    def build_nginx_config(key, value, section = nil)
      key = format('%s_%s', section.upcase, key.upcase) if %w(deployed_application deployed_stack).include?(section)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "fastcgi_param #{sub_key} \"#{item}\";\n"
        end
        return returnvalue
      end
      "fastcgi_param #{key} \"#{value}\";\n"
    end

    def build_ini_config(key, value, section = nil)
      if value.is_a?(Array)
        returnvalue = ''
        array_to_numbered_hash(key, value).each do |sub_key, item|
          returnvalue << "#{sub_key} = \"#{item}\"\n"
        end
        return returnvalue
      end
      "#{key} = \"#{value}\"\n"
    end

    def array_to_numbered_hash(key, arr)
      i = 0
      ret = {}
      arr.each do |item|
        subkey = format('%s[%s]', key, i)
        ret[subkey] = item
        i += 1
      end
      ret
    end

    def recursive_fetch(hash, keys)
      begin
        retval = keys.reduce(hash, :fetch)
      rescue KeyError
        retval = nil
      end
      retval
    end
  end
end
