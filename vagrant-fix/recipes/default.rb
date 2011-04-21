# for some reason, most VMs fail with outdated package lists
execute "aptitude update" do
  command "aptitude update"
end

execute "gem update"
