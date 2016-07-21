action :create do
  domain = new_resource.domain

  tmp = '/tmp'
  csr = "#{tmp}/#{domain}.csr"
  key = "#{tmp}/#{domain}.key"
  crt = "#{tmp}/#{domain}.crt"

  pass = "#{tmp}/#{domain}.pass"

  execute 'generate_crt' do
    command "openssl x509 -req -days 365 -in #{csr} -signkey #{key} -out #{crt}"
    action :nothing
  end

  csr_command = "openssl req -new -key #{key} -out #{csr}"
  csr_command << ' -subj "'
  csr_command << "/C=#{new_resource.country}"
  csr_command << "/ST=#{new_resource.state}"
  csr_command << "/L=#{new_resource.city}"
  csr_command << "/O=#{new_resource.organization}"
  csr_command << "/OU=#{new_resource.unit}"
  csr_command << "/CN=#{new_resource.domain}"
  csr_command << '"'

  execute 'generate_csr' do
    command csr_command
    action :nothing
    notifies :run, 'execute[generate_crt]', :immediately
  end

  execute 'delete_pass' do
    command "rm #{pass}"
    action :nothing
  end

  execute 'generate_key' do
    command "openssl rsa -passin pass:x -in #{pass} -out #{key}"
    action :nothing
    notifies :run, 'execute[generate_csr]', :immediately
    notifies :run, 'execute[delete_pass]', :immediately
  end

  execute 'generate_password' do
    command "openssl genrsa -des3 -passout pass:x -out #{pass} 4096"
    notifies :run, 'execute[generate_key]', :immediately
  end

  new_resource.updated_by_last_action(true)
end
