default[:gearman]         = {}
default[:gearman][:port]  = '31337'
default[:gearman][:debug] = "1"
default[:gearman][:pecl]  = '0.8.0'
default[:gearman][:http]  = 80

default[:silverline][:name] = "gearman-job-server"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name]
else
  default[:silverline][:environment] = "production"
end
