# only restart if this is an already running instance and the service wrapper is
# already available (= registered)
if File.exists?('/etc/init.d/elasticsearch')
  service "elasticsearch" do
    action :restart
  end
end
