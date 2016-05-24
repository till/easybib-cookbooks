default['stack-academy']['applications'] = {
  :infolit => {
    :layer => 'nginxphpapp',
    :nginx => {
      :cookbook => 'nginx-app',
      :conf => 'infolit.conf.erb'
    }
  },
  :rr_webeval => {
    :layer => 'nginxphpapp',
    :nginx => 'silex.conf.erb'
  }
}
