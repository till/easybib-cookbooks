package "mdadm"

gem_package "fog" do
  action :install
end

cookbook_file "/usr/local/bin/build-ebs-raid" do
  source "build-ebs-raid.rb"
  mode "0755"
  owner "root"
  group "root"
end

size     = node[:easybib_solr][:ebs][:size]
instance = node[:scalarium]?

execute "Create first volume: /dev/sdf" do
  command "/usr/local/bin/build-ebs-raid --zone=us-east-1b --size=#{size} --instance=#{instance} --device=/dev/sdf"
end

execute "Create first volume: /dev/sdg" do
  command "/usr/local/bin/build-ebs-raid --zone=us-east-1b --size=#{size} --instance=#{instance} --device=/dev/sdg"
end

# Todo
# raid 1 or 0
# install mdadm
# find instance id
# make.ext3
# create raid
# write /etc/mdadm/mdadm.conf

supports "ubuntu"