default[:gearman]         = {}
default[:gearman][:port]  = '31337'
default[:gearman][:debug] = "1"
default[:gearman][:pecl]  = '0.8.0'
default[:gearman][:http]  = 80

default[:silverline][:gearman_name] = "gearman-job-server"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name].gsub(/\s/,'')
else
  default[:silverline][:environment] = "production"
end
