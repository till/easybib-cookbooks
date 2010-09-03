package "mdadm"
package "xfsprogs"

include_recipe "easybib-solr::fog"

remote_file "/usr/local/bin/build-ebs-device" do
  source "build-ebs-device.rb"
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
fsystem  = node[:easybib_solr][:ebs][:file_system]

#execute "Create first volume: /dev/sdf" do
#  command "/usr/local/bin/build-ebs-device --zone=#{zone} --size=#{size} --instance=#{instance} --device=/dev/sdf"
#end

#execute "Create first volume: /dev/sdg" do
#  command "/usr/local/bin/build-ebs-device --zone=#{zone} --size=#{size} --instance=#{instance} --device=/dev/sdg"
#end


mdadm "#{raid}" do
  devices [ "/dev/sdf", "/dev/sdg" ]
  level level.to_i
  chunk 256
  action [ :create, :assemble ]
end

execute "Format #{mount} with #{fsystem}" do
  command "mkfs.#{fsystem} #{raid}"

  not_if do

    # wait for the device
    loop do
      if File.blockdev?(device)
        Chef::Log.info("device #{raid} ready")
        break
      else
        Chef::Log.info("device #{raid} not ready - waiting")
        sleep 10
      end
    end

    # check volume filesystem
    system("blkid -s TYPE -o value #{raid}")
  end
end

execute "Add #{mount} to /etc/fstab" do
  command "echo '#{raid} #{mount} #{fsystem} noatime 0 0' | sudo tee -a /etc/fstab"
end

mount "{mount}" do
  device raid
  fstype fsystem
end
