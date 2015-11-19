default['nginx-amplify'] = {
  'api_key' => nil,
  'version' => nil, # 0.23-1
  'apt' => {
    'key' => 'http://nginx.org/keys/nginx_signing.key',
    'repository' => 'http://packages.amplify.nginx.com/'
  }
}
