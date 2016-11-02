module NginxAmplify
  module Helper
    include Chef::Mixin::ShellOut

    def amplify_uuid
      cmd = shell_out!('/usr/bin/nginx-amplify-uuid-helper.py', :returns => [0])
      cmd.stdout
    end
  end
end

Chef::Resource.send(:include, ::NginxAmplify::Helper)
