include_recipe "easybib::role-generic"
include_recipe "getcourse-deploy::static"

if is_aws
  stack_applications = node['deploy'].keys
else
  stack_applications = ['consumer', 'domainadmin', 'management', 'signup']
end

stack_applications.each do |app|
  case app
  when 'consumer'
    include_recipe "nginx-app::getcourse-consumer"
  when 'domainadmin'
    include_recipe "nginx-app::getcourse-domainadmin"
  when 'management'
    include_recipe "nginx-app::getcourse-management"
  when 'signup'
    include_recipe "nginx-app::getcourse-signup"
  end
end
