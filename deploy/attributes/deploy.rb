unless node[:deploy].nil?

  deploy.each do |application, deploy|

    # if there's no opsworks
    next unless node[:opsworks]

    user = node[:opsworks][:deploy_user][:user]

    # there's absolutely no need for zsh
    set[:deploy][application][:shell] = '/bin/sh'

    case user
    when 'www-data'
      set[:deploy][application][:home] = '/var/www'
    when 'root'
      set[:deploy][application][:home] = '/root'
    else
      set[:deploy][application][:home] = "/home/#{user}"
    end

    Chef::Log.info("User: #{user}, Home: #{node[:deploy][application][:home]}") 


  end
end
