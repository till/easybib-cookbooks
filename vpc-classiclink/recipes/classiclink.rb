#
# Cookbook Name:: vpc-classiclink
# Recipe:: classiclink
#

instance = get_instance

instance_id = instance['aws_instance_id']
vpc_id = node.fetch('vpc-classiclink', {}).fetch('classiclink_vpc_id', '')
sg = node.fetch('vpc-classiclink', {}).fetch('classiclink_security_group_id', '')

execute 'attach-classiclink-to' do
  command "aws ec2 attach-classic-link-vpc --instance-id #{instance_id} --vpc-id #{vpc_id} --groups #{sg}"
  not_if do
    vpc_id.empty? || sg.empty?
  end
end
