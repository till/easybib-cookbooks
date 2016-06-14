default['logrotate']['global']['/mnt/logs/rabbitmq/*.log'] = {
  :missingok  => true,
  :monthly    => true,
  :create     => '0660 root adm',
  :rotate     => 1,
  :prerotate  => ['rabbitmq start_rotate', 'logger started rabbitmq log rotation'],
  :postrotate => <<-EOF
    rabbitmq end_rotate
    logger completed rabbitmq log rotation
  EOF
}
