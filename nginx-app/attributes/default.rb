default["nginx-app"]                      = {}
default["nginx-app"][:user]               = "www-data"
default["nginx-app"][:group]              = "www-data"
default["nginx-app"][:static_directories] = ["js", "css", "images", "raw"]

# Silverline attribs
default[:silverline][:nginx_name] = "nginx"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name].gsub(/\s/,'')
else
  default[:silverline][:environment] = "production"
end

