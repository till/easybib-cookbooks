default['stack-academy']['applications'] = {
  :infolit => {
    :layer => 'nginxphpapp',
    :nginx => {
      :cookbook => 'stack-academy',
      :conf => 'infolit.conf.erb'
    }
  },
  :rr_webeval => {
    :layer => 'nginxphpapp',
    :nginx => 'silex.conf.erb'
  }
}
