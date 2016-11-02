default['easybib_deploy']['php-fpm']['restart-action'] = :reload

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
