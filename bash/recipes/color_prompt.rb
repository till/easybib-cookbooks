prompt_color = prompt_mono = '${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\$ '

if ::EasyBib.is_aws(node)
  if node['easybib_deploy']['envtype'] == 'production'
    prompt_color = '${debian_chroot:+($debian_chroot)}\\[\\e[33;1;41m\\]\\u@\\h:\\w\\$\\[\\e[0m\\] '
    prompt_mono = 'PROD ${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\$ '
  else
    prompt_color = '${debian_chroot:+($debian_chroot)}\\[\\e[33;1;44m\\]\\u@\\h:\\w\\$\\[\\e[0m\\] '
  end
end

unless node['ssh_users'].nil?
  node['ssh_users'].each do |id, user|
    template "/home/#{user['name']}/.bashrc" do
      source 'user.bashrc.erb'
      variables(
        :prompt_color => prompt_color,
        :prompt_mono => prompt_mono
      )
      user user['name']
      mode   '0644'
    end
  end
end
