#
# Cookbook Name:: vpc-classiclink
# Recipe:: classiclink
#

bash "attach-classiclink-to" do
  code "aws ec2 attach-classic-link-vpc --instance-id #{node["opsworks"]["instance"]["aws_instance_id"]} --vpc-id #{node["vpc-classiclink"]["classiclink_vpc_id"]} --groups #{node["vpc-classiclink"]["classiclink_security_group_id"]}"
end
