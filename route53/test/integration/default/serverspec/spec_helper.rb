require 'serverspec'
require 'pathname'

set :backend, :exec
set :path, "/sbin:/usr/local/sbin:$PATH"
