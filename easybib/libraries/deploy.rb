module EasyBib
  module Deploy
    def deploy_crontab?(instance_roles, cronjob_role)
      if cronjob_role.nil?
        return true
      end

      if instance_roles.include?(cronjob_role)
        return true
      end

      Chef::Log.info('Instance is not in a cronjob role, skippings cronjob installs')

      false
    end

    # Checks if an application is allowed to be deployed - if the currently to be deployed
    # app matches the one we expect, and if the role of the instances is in an appropriate
    # role for the app.
    #
    # application - current application to be deployed
    # requested_application - app we are expecting, can also be array of names
    # requested_role - role we are expecting, can also be array of role names. if nil, rolename=appname
    #
    # @return [Boolean]
    def allow_deploy(application, requested_application, requested_role = nil, node = self.node)
      unless ::EasyBib.is_aws(node)
        Chef::Log.debug('We are not running in a cloud environment, skipping deploy.')
        return false
      end

      if requested_application.is_a?(Array)
        allow = false
        requested_application.each do |current_requested_application|
          # allow if any of requested_applications is allowed, so lets use OR:
          allow ||= allow_deploy(application, current_requested_application, requested_role, node)
        end
        return allow
      end

      if requested_role.is_a?(Array)
        allow = false
        requested_role.each do |current_requested_role|
          allow ||= allow_deploy(application, requested_application, current_requested_role, node)
        end
        return allow
      end

      instance_roles = ::EasyBib.get_instance_roles(node)

      Chef::Log.info(
        "deploy #{requested_application} - requested app: #{application}, role: #{instance_roles}"
      )
      if requested_role.nil?
        requested_role = requested_application
      end

      if requested_application.is_a?(String)
        return is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
      else
        raise 'Unknown value type supplied for requested_role in allow_deploy'
      end
    end

    def is_app_configured_for_stack(application, requested_application, requested_role, instance_roles)
      if application == requested_application
        unless instance_roles.include?(requested_role)
          irs = instance_roles.inspect
          Chef::Log.info("deploy #{requested_application} - skipping: #{requested_role} is not in (#{irs})")
          return false
        end

        Chef::Log.info("deploy #{requested_application} - allowing deploy")
        return true
      end

      Chef::Log.info("deploy #{requested_application} - #{application} skipped")
      false
    end

    private :is_app_configured_for_stack
  end
end

Chef::Provider.send(:include, ::EasyBib::Deploy)
Chef::Recipe.send(:include, ::EasyBib::Deploy)
Chef::Resource.send(:include, ::EasyBib::Deploy)
