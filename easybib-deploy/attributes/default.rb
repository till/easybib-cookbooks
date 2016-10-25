default['easybib_deploy']['php-fpm']['restart-action'] = :reload

default['ssl-deploy']              = {}
default['ssl-deploy']['directory'] = '/etc/nginx/ssl'
default['ssl-deploy']['ssl-role']  = 'nginxphpapp'

default['bibcd']['apps'] = {}

default['travis-asset-browser']['config'] = {
  'theme' => 'plain',
  'page-header' => 'My Amazon S3 files',
  's3-access-key' => '',
  's3-secret-key' => '',
  'cache-time' => 600,
  'cache-dir' => '/tmp',
  'bucket-name' => '',
  'bucket-url-prefix' => 'http://bucket-name.s3.amazonaws.com'
}
