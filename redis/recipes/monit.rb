template "/etc/monit/conf.d/redis.monitrc" do
  source "redis.monit.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "monit reload" do
  action :run
end
