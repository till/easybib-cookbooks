default[:ganglia_plugins] = {}
default[:ganglia_plugins][:conf_dir] = '/etc/ganglia/conf.d'
default[:ganglia_plugins][:plugin_dir] = '/etc/ganglia/python_modules'
default[:ganglia_plugins][:nginx][:status] = '/nginx_status'