# install the example application and prepare it

solr_app  = node[:apache_solr][:app]
solr_base = "#{node[:apache_solr][:base_dir]}/solr/"

execute "copy config from git to #{solr_base}" do
  cwd     solr_base
  command "cp -R #{node[:apache_solr][:config_source_dir]}/* #{solr_base}"
end