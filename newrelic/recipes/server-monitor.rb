commands = [
  "apt-get install newrelic-sysmond",
  "nrsysmond-config --set license_key=#{node["newrelic"]["license"]}"
]

commands.each do |cmd|
  execute "#{cmd}"
end
