if node['lsb']['codename'] == 'xenial'
  package 'openjdk-9-jre-headless'
else
  package 'openjdk-6-jre-headless'
  package 'openjdk-6-jre-lib'
end
