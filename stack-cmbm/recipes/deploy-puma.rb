puma_apps = [
  %w(/vagrant_cmbm vagrant /vagrant_cmbm/config/puma.rb /vagrant_cmbm/log/puma.log)
]

# This configuration file is required by `supervisorctl`. It resembles a CSV with one process configuration per line.
template '/etc/puma.conf' do
  source 'puma.conf.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables :apps => puma_apps
end

# Create run directory for puma. This is need by supervisor to store the global puma pidfile.
directory '/var/run/puma' do
  user 'vagrant'
  group 'vagrant'
  mode '0755'
end
