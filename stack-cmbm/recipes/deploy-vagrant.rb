node['vagrant']['applications'].each do |app_name, app_data|
  next unless %w(cmbm).include?(app_name)
  app_dir            = app_data['app_dir']
  tmp_dir            = "#{app_dir}/tmp"
  directory tmp_dir do
    mode '0777'
    action :create
    ignore_failure true
  end
end
