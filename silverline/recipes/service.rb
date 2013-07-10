service "silverline" do
  case node[:platform]
  when "ubuntu"
    if node[:platform_version].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  supports :restart => true, :start => true
end
