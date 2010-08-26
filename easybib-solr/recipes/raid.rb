package "mdadm"
package "xfsprogs"

gem_package "fog" do
  action :install
end

remote_file "/usr/local/bin/build-ebs-raid" do
  source "build-ebs-raid.rb"
  mode "0755"
  owner "root"
  group "root"
end

size     = node[:easybib_solr][:ebs][:size]
instance = node[:ec2][:instance_id]
raid     = "/dev/md0"
level    = node[:easybib_solr][:ebs][:raid]
mount    = node[:easybib_solr][:working_directory]
zone     = node[:easybib_solr][:ebs][:zone]

execute "Create first volume: /dev/sdf" do
  command "/usr/local/bin/build-ebs-raid --zone=#{zone} --size=#{size} --instance=#{instance} --device=/dev/sdf"
end

execute "Create first volume: /dev/sdg" do
  command "/usr/local/bin/build-ebs-raid --zone=#{zone} --size=#{size} --instance=#{instance} --device=/dev/sdg"
end


mdadm "#{raid}" do
  devices [ "/dev/sdf", "/dev/sdg" ]
  level level.to_i
  chunk 256
  action [ :create, :assemble ]
end

execute "Format #{mount}" do
  command "mkfs.xfs #{raid}"
end

execute "Add #{mount} to /etc/fstab" do
  command "echo '#{raid} #{mount} xfs noatime 0 0' | sudo tee -a /etc/fstab"
end

mount "{mount}" do
  device raid
  fstype "xfs"
end

supports "ubuntu"