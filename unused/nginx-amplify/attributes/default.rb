default['nginx-amplify'] = {
  'api_key' => nil,
  'version' => nil, # 0.23-1
  'hostname' => '',
  'apt' => {
    'key' => 'nginx_signing.key',
    'repository' => 'http://packages.amplify.nginx.com/'
  }
}
