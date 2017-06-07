#
# Cookbook Name:: vpc-classiclink
# Recipe:: classiclink
#

this_instance = get_instance

instance_id = this_instance['aws_instance_id'] unless this_instance == false
vpc_id = node.fetch('vpc-classiclink', {}).fetch('classiclink_vpc_id', '')
sg = node.fetch('vpc-classiclink', {}).fetch('classiclink_security_group_id', '')
region = node.fetch('vpc-classiclink', {}).fetch('region', '')

opts = ["--instance-id #{instance_id}", "--vpc-id #{vpc_id}", "--groups #{sg}", "--region #{region}"]

execute 'attach-classiclink-to' do
  command "aws ec2 attach-classic-link-vpc #{opts.join(' ')}"
  not_if do
    vpc_id.empty? || sg.empty?
  end
end
