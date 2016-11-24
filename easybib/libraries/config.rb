require_relative 'configfile.rb'
module EasyBib
  module Config
    extend self

    # returns env settings and information about the stack, application env, and rds
    def get_configcontent(format, appname, node = self.node, stackname = 'getcourse')
      settings = {}
      settings.merge!(envsettings_from_stack(stackname, node))
      settings.merge!(envsettings_from_app(appname, node))
      Chef::Log.info("no env settings found - appname was #{appname}, stack #{stackname}") if settings.empty?

      settings.merge!(envsettings_from_dbconfig(appname, node))
      settings.merge!(envsettings_puma_for_cmbm(node))

      data = {
        'deployed_application' => get_appdata(node, appname),
        'deployed_stack' => get_stackdata(node),
        'settings' => settings
      }
      ::EasyBib::ConfigFile.new.to_configformat(format, data)
    end

    # returns domains for appname
    def get_domains(node, appname)
      domains = ::WT::Data::Injector.get_apps_to_deploy(node).fetch(appname, {})['domains']
      return domains.join(' ') if domains.respond_to?('join')
      domains
    end

    # returns application metadata (name, domains, directories)
    def get_appdata(node, appname)
      application_info = ::WT::Data::Injector.get_apps_to_deploy(node)[appname]
      data = {}
      data['appname'] = application_info['application'].nil? ? appname : application_info['application']
      data['domains'] = get_domains(node, appname)
      data['deploy_dir'] = application_info['deploy_to']
      data['app_dir'] = ::EasyBib.is_aws(node) ? "#{application_info['deploy_to']}/current/" : application_info['deploy_to']
      data['doc_root_dir'] = "#{data['app_dir']}#{application_info['document_root']}"

      # ensure all dirs end with a slash:
      %w(deploy_dir app_dir doc_root_dir).each do |name|
        next if data[name].nil?
        data[name] << '/' unless data[name].end_with?('/')
      end
      data
    end

    protected

    def envsettings_from_stack(stackname, node)
      return {} if node.fetch(stackname, {})['env'].nil?
      Chef::Log.info("env settings for stack #{stackname} found")
      streamline_appenv(node[stackname]['env'])
    end

    def envsettings_from_app(appname, node)
      return {} unless node.attribute?(appname) && node[appname].attribute?('env')
      Chef::Log.info("env settings for app #{appname} found")
      streamline_appenv(node[appname]['env'])
    end

    def envsettings_from_dbconfig(appname, node)
      return {} if node.fetch('deploy', {}).fetch(appname, {}).fetch('database', {})['host'].nil?
      # add configuration from the RDS resource management in opsworks
      Chef::Log.info('found configured rds resource, adding to envvars')
      dbconfig = streamline_appenv('db' => node['deploy'][appname]['database'])
      dbconfig = append_database_url_to_dbconfig(dbconfig)

      dbconfig
    end

    def envsettings_puma_for_cmbm(node)
      streamline_appenv('puma' => node.fetch('stack-cmbm', {}).fetch('puma', {}))
    end

    # returns stack metadata (name, environment-type)
    def get_stackdata(node, attribute = nil)
      data = {}

      data['environment'] = node['easybib_deploy']['envtype']

      if ::EasyBib.is_aws(node)
        data['stackname'] = node['opsworks']['stack']['name']
      elsif node['vagrant']
        data['stackname'] = 'vagrant'
        data['environment'] = 'vagrant'
      else
        data['stackname'] = 'undefined'
      end

      return data[attribute] unless attribute.nil?

      data
    end

    def streamline_appenv(data, prefix = '')
      returnparam = {}
      return returnparam if data.nil?

      data.each_pair do |section, part_data|
        section = get_returnparam_identifier(section, prefix)
        content = get_returnparam(section, part_data)

        returnparam.merge!(content)
      end
      returnparam
    end

    def get_returnparam_identifier(section, prefix)
      return format('%s_%s', prefix, section.upcase) if prefix != ''
      section.upcase
    end

    # rubocop:disable Style/GuardClause
    def get_returnparam(section, part_data)
      if part_data.is_a?(Hash)
        return streamline_appenv(part_data, section)
      elsif part_data.is_a?(Array)
        return { section => part_data }
      elsif part_data.is_a?(String)
        return { section => part_data }
      elsif part_data.respond_to?('to_s')
        return { section => part_data.to_s }
      end
      # rubocop:enable Style/GuardClause

      raise "I have no idea how to deal with config item #{section}."
    end

    def append_database_url_to_dbconfig(dbconfig)
      return unless dbconfig

      return dbconfig unless dbconfig['DB_DATABASE']
      return dbconfig unless dbconfig['DB_HOST']
      return dbconfig unless dbconfig['DB_PORT']
      return dbconfig unless dbconfig['DB_USERNAME']
      return dbconfig unless dbconfig['DB_PASSWORD']

      db_type = dbconfig['DB_TYPE'] == 'mysql' ? 'mysql2' : dbconfig['DB_TYPE']

      db_url = "#{db_type}://#{dbconfig['DB_USERNAME']}:#{dbconfig['DB_PASSWORD']}@" \
               "#{dbconfig['DB_HOST']}:#{dbconfig['DB_PORT']}/" \
               "#{dbconfig['DB_DATABASE']}?reconnect=#{dbconfig['DB_RECONNECT']}"

      dbconfig['DATABASE_URL'] = db_url

      dbconfig
    end
  end
end

Chef::Provider.send(:include, ::EasyBib::Config)
Chef::Recipe.send(:include, ::EasyBib::Config)
Chef::Resource.send(:include, ::EasyBib::Config)
