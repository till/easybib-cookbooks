deploy.each do |application, deploy|
  default[:deploy][application][:user] = 'www-data'
end