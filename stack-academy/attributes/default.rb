default['stack-academy']['applications'] = {
  :infolit => {
    :layer => 'nginxphpapp',
    :nginx => 'infolit.conf.erb'
  },
  :rr_webeval => {
    :layer => 'nginxphpapp',
    :nginx => 'silex.conf.erb'
  }
}
