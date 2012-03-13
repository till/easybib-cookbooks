include_recipe "apache-solr::prepare"
include_recipe "apache-solr::service"

apache_solr_version = node[:apache_solr][:version]
apache_solr_release = "apache-solr-#{apache_solr_version}.zip"

base_dir = node[:apache_solr][:base_dir]

remote_file "#{base_dir}/#{apache_solr_release}" do
  owner  node[:apache_solr][:user]
  group  node[:apache_solr][:group]
  source "#{node[:apache_solr][:mirror]}/#{apache_solr_version}/#{apache_solr_release}"
  not_if do
    File.exists?("#{base_dir}/#{apache_solr_release}")
  end
end

execute "unzip the #{apache_solr_release} file" do
  cwd     base_dir
  command "pwd && unzip #{apache_solr_release}"
  creates "#{base_dir}/apache-solr-#{apache_solr_version}"
end

link "#{base_dir}/apache-solr" do
  owner    node[:apache_solr][:user]
  group    node[:apache_solr][:group]
  to       "#{base_dir}/apache-solr-#{apache_solr_version}"
end
