if node.attribute?('getcourse')

  env_conf = get_env_for_shell('getcourse')

  template '/etc/profile.d/getcourse.sh' do
    source 'profile.erb'
    mode '0755'
    variables :env => env_conf
    not_if do
      env_conf.empty?
    end
  end

end

cookbook_file '/etc/profile.d/bib-alias.sh' do
  source 'alias.sh'
  mode   '0755'
end
