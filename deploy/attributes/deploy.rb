unless node[:deploy].nil?

  deploy.each do |application, deploy|

    # if there's no scalarium
    next unless !node[:scalarium]

    # if there is no override
    next unless !node[:scalarium][:deploy_user][:user].nil?

    # there's absolutely no need for zsh
    node[:deploy][application][:shell] = '/bin/sh'

    case node[:scalarium][:deploy_user][:user]
    when 'www-data'
      node[:deploy][application][:home] = '/var/www'
    when 'root'
      node[:deploy][application][:home] = '/root'
    else
      node[:deploy][application][:home] = "/home/#{node[:scalarium][:deploy_user][:user]}"
    end

    Chef::Log.info("User: #{node[:scalarium][:deploy_user][:user]}, Home: #{node[:deploy][application][:home]}")

  end
end
