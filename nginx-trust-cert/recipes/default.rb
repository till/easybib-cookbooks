# copy the nginx ssl cert to the ca cert folder
remote_file 'Copy certificate' do 
  path   '/usr/share/ca-certificates/nginx.crt'
  source 'file:///etc/nginx/ssl/cert.pem'
  owner  'root'
  group  'root'
  mode   '0644'
end

# add the cert to the list of trusted ca certs
ruby_block 'Insert certificate' do
  block do
    file = Chef::Util::FileEdit.new('/etc/ca-certificates.conf')
    file.insert_line_if_no_match('/nginx.crt/', 'nginx.crt')
    file.write_file
  end
end

# update certificates
execute 'Update certificates' do
  command 'update-ca-certificates'
end
