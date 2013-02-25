unless node[:deploy].nil?

  deploy.each do |application, deploy|

    # if there's no opsworks
    next unless ::EasyBib.is_aws() == true

    deploy_user = get_deploy_user()
    user        = deploy_user[:user]

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
