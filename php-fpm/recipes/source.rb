compile_deps = ["build-essential", "autoconf", "make"]
compile_deps.each do |dep|
  package dep do
    action :install
  end
  Chef::Log.debug("Installed '#{dep}' so we can compile.")
end
