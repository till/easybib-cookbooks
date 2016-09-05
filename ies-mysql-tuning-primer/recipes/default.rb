package 'mysql-client'

remote_file '/usr/local/bin/ies-mysql-tuning-primer.sh' do
  source 'https://raw.githubusercontent.com/easybiblabs/mysql-tuning-primer/master/tuning-primer.sh'
  owner 'root'
  group 'root'
  mode '0755'
end
