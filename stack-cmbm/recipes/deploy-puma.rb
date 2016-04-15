puma_tools = {
  '/usr/local/bin/run-puma' => 'puma-run',
  '/usr/local/bin/run-pumactl' => 'pumactl-run'
}
puma_apps = [
  %w(/vagrant_cmbm vagrant /vagrant_cmbm/config/puma.rb /vagrant_cmbm/log/puma.log)
]

puma_tools.each do |abs_path, source_file|
  cookbook_file abs_path do
    source source_file
    user 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

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
