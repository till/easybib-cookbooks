force_default['haproxy']['ssl']         = 'on'
force_default['haproxy']['type']        = '1.5'
force_default['ssl-deploy']['ssl-role'] = 'lb'

default['stack-scholar']['applications'] = {
  :scholar => {
    :layer => nil,
    :nginx => 'scholar.conf.erb',
    :nginx_config => {
      :listen_opts => 'default_server'
    }
  },
  :scholar_admin => {
    :layer => 'nginxphpapp',
    :nginx => 'silex.conf.erb'
  },
  :scholar_realtime => {
    :layer => nil,
    :nginx => nil
  }
}
