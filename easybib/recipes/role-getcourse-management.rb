easybib/recipes/role-getcourse-signup.rb                                                                                      [16:45:31]
include_recipe "easybib::role-generic"

include_recipe "getcourse-deploy::static"
include_recipe "nginx-app::getcourse-management"
