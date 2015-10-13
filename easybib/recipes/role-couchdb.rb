include_recipe 'ies::role-generic'
include_recipe 'apache-couchdb'   # default.rb includes configure.rb, which includes service.rb
