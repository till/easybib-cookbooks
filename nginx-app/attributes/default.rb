default["nginx-app"]                      = {}
default["nginx-app"][:user]               = "www-data"
default["nginx-app"][:group]              = "www-data"
default["nginx-app"][:static_directories] = ["js", "css", "images", "raw"]

# for localhost, vagrant
#set_unless[:deploy][:deploy_to] = "/vagrant"

# Silverline attribs
default[:silverline][:name] = "nginx"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name]
else
  default[:silverline][:environment] = "production"
end

