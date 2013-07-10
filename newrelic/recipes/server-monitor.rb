commands = [
  "apt-get install newrelic-sysmond",
  "nrsysmond-config --set license_key=#{node["newrelic"]["license"]}"
]

commands.each do |cmd|
  execute "#{cmd}"
end

include_recipe "newrelic::service"

service "newrelic-sysmond" do
  action :start
end
