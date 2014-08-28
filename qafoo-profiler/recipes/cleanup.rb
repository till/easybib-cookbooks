include_recipe "qafoo-profiler::service"

service "qprod" do
  action :stop
end

execute "stop qprofd hard" do
  command "killall qprofd"
  ignore_failure true
end

execute "cleanup socket file" do
  command "rm -f /tmp/qprofd.sock"
  ignore_failure true
end
