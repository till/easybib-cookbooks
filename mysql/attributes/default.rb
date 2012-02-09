default[:silverline][:name] = "mysql-sessions"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name]
else
  default[:silverline][:environment] = "production"
end
