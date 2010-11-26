node[:dev][:users].each do |user|
  group "sudo" do
    members "#{user}"
    append true
  end
end

remote_file "/etc/sudoers" do
  mode 0440
  owner "root"
  group "root"
  source "sudoers"
end
