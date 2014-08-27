execute "stop qprofd nicely" do
  command "stop qprofd"
  ignore_failure true
end

execute "stop qprofd hard" do
  command "killall qprofd"
  ignore_failure true
end

execute "cleanup socket file" do
  command "rm -f /tmp/qprofd.sock"
  ignore_failure true
end
