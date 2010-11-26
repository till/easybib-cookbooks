node[:dev][:users].each do |user|
  execute "fix perm" do
    command "chown -R #{user}:#{user} /home/#{user}"
  end
end
