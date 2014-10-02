execute 'delete all old dashboards' do # ~FC041
  command "curl  -XDELETE 'http://localhost:9200/kibana-int/dashboard/_all' "
end

node['packetbeat']['dashboards'].each do |name|

  cookbook_file "#{Chef::Config['file_cache_path']}/#{name}.json"  do
    source "dashboards/#{name}.json"
  end

  execute "create packetbeat schema #{name}" do # ~FC041
    command "curl  -XPUT 'http://localhost:9200/kibana-int/dashboard/#{name}' -d@#{Chef::Config['file_cache_path']}/packetbeat.template.json"
  end
end
