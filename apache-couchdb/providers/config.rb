use_inline_resources if defined?(use_inline_resources)

def get_host(host)
  if host != '0.0.0.0'
    return host
  end

  '127.0.0.1'
end

def is_running?
  local_only?
end

def local_only?
  # warning: NO SSL here (yet)
  http = make_http('127.0.0.1', 5984)
  begin
    http.request(Net::HTTP::Get.new('/'))
    true
  rescue
    false
  end
end

# warning: NO SSL here (yet)
def make_http(host, port)
  # warning: NO SSL here (yet)
  Net::HTTP.new(host, port)
end

# create put request
def make_put(call, body, user, passwd)
  req = Net::HTTP::Put.new(call)
  req['Content-Type'] = 'application/json'
  req.basic_auth user, passwd unless user.nil?
  req.body = body.to_json
  req
end

# write local ini files
def write_ini(config_file, section, config)
  Chef::Log.debug("Writing: #{config_file}")
  t = template "#{config_file}" do
    cookbook 'apache-couchdb'
    source 'local.ini.erb'
    owner 'couchdb'
    group 'couchdb'
    variables(
      :section => section,
      :config => config
    )
  end

  t
end

def write_section(section)
  @couchdb_config[section].each do |config_key, config_value|

    re_tries = @new_resource.re_try

    @http = make_http(@host, @port)

    call = "/_config/#{section}/#{config_key}"
    Chef::Log.info("PUT #{call}")

    req = make_put(
      call,
      config_value,
      @username,
      @password
    )

    begin
      @http.request(req)
    rescue StandardError => e
      Chef::Log.fatal("Failed to set configuration: #{e.message}")

      re_tries -= 1
      if re_tries > 0
        Chef::Log.debug("Re-tries left: #{re_tries}/#{@new_resource.re_try}")
        retry
      end

      Chef::Log.fatal("Gave up on: #{call} after #{@new_resource.re_try}")
    end

    next unless section == 'httpd'

    @host = config_value if config_key == 'bind_address'
    @port = config_value if config_key == 'port'
  end

  success
end

action :add do
  unless ::File.exist?(new_resource.etc_dir)
    Chef::Log.fatal("#{new_resource.etc_dir} does not exist.")
  end

  @couchdb_config = new_resource.config
  # etc_dir = new_resource.etc_dir

  # username = nil
  # password = nil

  needs_restart = false

  # then 'admins'
  # if config.key?('admins') && config['admins'].length > 0
  #  Chef::Log.debug('Setting up admin accounts for ')

  #  tpl = write_ini("#{etc_dir}/local.ini", 'admins', config['admins'])
  #  tpl.run_action(:create)

  #  username, password = config['admins'].first

  #  needs_restart = true
  # end

  Chef::Log.debug("Is CouchDB running: #{is_running?}")
  Chef::Log.debug("Do we need a restart: #{needs_restart}")

  exe = execute 'brute_force_restart' do
    action :nothing
    command 'restart couchdb && sleep 10' # lolz
  end
  exe.run_action(:run) if needs_restart == true

  @host = get_host(new_resource.host)
  @port = new_resource.port

  if local_only?
    @host = '127.0.0.1'
    @port = 5984
  end

  # write 'httpd' first
  # if @couchdb_config.key?('httpd')
  #  write_section('httpd')
  # end

  # warning: NO SSL here (yet)
  # http = make_http(host, port)
  Chef::Log.info("CouchDB @ #{@host}:#{@port}")
  Chef::Log.debug("Re-try set to: #{@new_resource.re_try}")

  # then the rest
  @couchdb_config.each_key do |section|
    next if %w('admins', 'httpd').include?(section)

    Chef::Log.debug("Write section #{section}: #{re_tried}/#{@new_resource.re_try}")
    write_section(section)
  end

  # TODO: 'admins'

end

action :remove do
  Chef::Log.fatal('not implemented')
end
