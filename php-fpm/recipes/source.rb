['build-essential', 'autoconf', 'make'].each do |dep|
  package dep do
    action :install
  end
  Chef::Log.debug("Installed '#{dep}' so we can compile.")
end
