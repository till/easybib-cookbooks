execute 'apt-get update' do
  command 'apt-get update'
end

execute 'apt-get install #{node["apt"]["upgrade-package"]}' do
  command 'apt-get install -y #{node["apt"]["upgrade-package"]}'
  not_if node["apt"]["upgrade-package"].nil?
end
