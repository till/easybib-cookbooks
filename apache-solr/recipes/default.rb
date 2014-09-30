include_recipe 'apache-solr::prepare'
include_recipe 'apache-solr::service'

apache_solr_version = node['apache_solr']['version']
apache_solr_release = "solr-#{apache_solr_version}.zip"
apache_solr_dirname = "solr-#{apache_solr_version}"

base_dir = node['apache_solr']['base_dir']

remote_file "#{Chef::Config['file_cache_path']}/#{apache_solr_release}" do
  owner  node['apache_solr']['user']
  group  node['apache_solr']['group']
  source "#{node['apache_solr']['mirror']}/#{apache_solr_version}/#{apache_solr_release}"
  not_if do
    File.exist?("#{Chef::Config['file_cache_path']}/#{apache_solr_release}")
  end
end

execute "unzip the #{apache_solr_release} file" do
  cwd     Chef::Config['file_cache_path']
  command "pwd && unzip #{apache_solr_release}"
end

execute 'moving the preconfigured example to our dist' do
  cwd     Chef::Config['file_cache_path']
  command "mv #{Chef::Config['file_cache_path']}/#{apache_solr_dirname}/example #{base_dir}/#{apache_solr_dirname}"
  creates "#{base_dir}/#{apache_solr_dirname}"
end

directory "#{Chef::Config['file_cache_path']}/#{apache_solr_dirname}" do
  action :delete
  recursive true
end

['example-DIH', 'exampledocs', 'example-schemaless', 'solr/collection1'].each do |example_dir|
  directory "#{base_dir}/#{apache_solr_dirname}/#{example_dir}" do
    action :delete
    recursive true
  end
end

link "#{base_dir}/solr" do
  owner    node['apache_solr']['user']
  group    node['apache_solr']['group']
  to       "#{base_dir}/solr-#{apache_solr_version}"
end
