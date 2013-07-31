cookbook_file "/usr/local/bin/nginxstats" do
  source "nginxstats.py"
  mode 0755
  owner "root"
  group "root"
end
