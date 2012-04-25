# install the example application and prepare it

solr_app  = node[:apache_solr][:app]
solr_base = "#{node[:apache_solr][:base_dir]}/apache-solr"

if !File.directory?("#{solr_base}/#{solr_app}")

  execute "copy examples to #{solr_app}" do
    cwd     solr_base
    command "cp -R example #{solr_app}"
    only_if do
      File.directory?("#{solr_base}/example")
    end
  end

  # this should keep solr from starting and error accordingly ;)
  execute "delete standard schema.xml" do
    cwd     "#{solr_base}/#{solr_app}/solr/conf"
    only_if do
      File.exists?("#{solr_base}/#{solr_app}/solr/conf/schema.xml")
    end
    command "rm schema.xml"
  end

end
