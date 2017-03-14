default['stack-easybib']['static_extensions'] = %w(jpg jpeg gif png css js ico woff ttf eot map ico svg)

default['nginx-app']['browser_caching']['enabled'] = false
default['nginx-app']['browser_caching']['config']['eot|ttf|woff'] = {
  'expires' => 'max',
  'headers' => [
    'Access-Control-Allow-Origin *'
  ]
}

default['nginx-app']['browser_caching']['config']['jpg|jpeg|png|gif|ico'] = {
  'expires' => 'max',
  'headers' => [
    'Cache-Control "public, must-revalidate, proxy-revalidate"',
    'Pragma public'
  ]
}

default['nginx-app']['browser_caching']['config']['css|svg|map|js'] = {
  'expires' => 'max',
  'headers' => [
    'Cache-Control "public, must-revalidate, proxy-revalidate"',
    'Pragma public',
    'Vary "Accept-Encoding"'
  ]
}

default['stack-easybib'] = {
    'php_version' => '5.6'
}
