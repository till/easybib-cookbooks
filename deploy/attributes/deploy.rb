unless node[:deploy].nil?

  deploy.each do |application, deploy|

    # if there's no scalarium
    next unless node[:scalarium]

    # there's absolutely no need for zsh
    set[:deploy][application][:shell] = '/bin/sh'

    case node[:scalarium][:deploy_user][:user]
    when 'www-data'
      set[:deploy][application][:home] = '/var/www'
    when 'root'
      set[:deploy][application][:home] = '/root'
    else
      set[:deploy][application][:home] = "/home/#{node[:scalarium][:deploy_user][:user]}"
    end

    Chef::Log.info("User: #{node[:scalarium][:deploy_user][:user]}, Home: #{node[:deploy][application][:home]}")

  end
end
