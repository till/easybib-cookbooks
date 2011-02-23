define :jenkins_plugin do
  plugin_dir = "/var/lib/jenkins/plugins"

  # When bootingstrapping a race condition can arrise where this dir hasn't been created yet...
  directory plugin_dir do
    recursive true
    owner "jenkins"
    mode 0700
    not_if "test -d #{plugin_dir}"
  end

  plugins_to_install = params[:name].select do |plugin_name, version|
    manifest = "#{plugin_dir}/#{plugin_name}/META-INF/MANIFEST.MF"
    !(File.exist?(manifest) && File.read(manifest)["Plugin-Version: #{version.strip}"])
  end

  plugins_to_install.each do |plugin_name, version|
    execute "remove previous jenkins plugin version: #{plugin_name}" do
      user "jenkins"
      command "rm #{plugin_dir}/#{plugin_name}.hpi"
      only_if "test -f #{plugin_dir}/#{plugin_name}.hpi"
    end
    remote_file "#{plugin_dir}/#{plugin_name}.hpi" do
      owner "jenkins"
      if version == "latest"
        source "http://updates.jenkins-ci.org/latest/#{plugin_name}.hpi"
      else
        source "http://updates.jenkins-ci.org/download/plugins/#{plugin_name}/#{version}/#{plugin_name}.hpi"
      end  
    end
  end

  unless plugins_to_install.empty?
    service "jenkins" do
      action :restart
    end
  end
end

