user node["redis"]["user"] do
  shell  "/bin/zsh"
  action :create
  only_if do
    node["redis"]["user"] != 'root'
  end
end
