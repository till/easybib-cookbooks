puma_apps = [
  %w(/vagrant_cmbm vagrant /vagrant_cmbm/config/puma.rb /vagrant_cmbm/log/puma.log)
]

# Create run directory for puma.
directory '/var/run/puma' do
  user 'vagrant'
  group 'vagrant'
  mode '0755'
end

template '/etc/puma.conf' do
  source 'puma.conf.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables :apps => puma_apps
end
