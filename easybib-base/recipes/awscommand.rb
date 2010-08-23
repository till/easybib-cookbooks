package "curl"

cookbook_file "/usr/local/bin/aws" do
  source "aws"
  mode 0755
  owner "root"
  group "root"
end

execute "Create convenience commands." do
  command "/usr/local/bin/aws --link"
end

file "/root/.awssecret" do
  source "awssecret.erb"
  mode "0600"
  owner "root"
  group "root"
end