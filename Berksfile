source 'http://localhost:65535/'

root_dir = File.expand_path('../', __FILE__)

puts root_dir.to_s

Dir["#{root_dir}/**"].each do |path|
  cb = File.basename(path)

  next if ['fc_sandbox', 'rails', 'stack-scholar', 'vagrant-test'].include?(cb)
  next unless File.directory?(path)
  # puts "#{cb}/#{path}"

  cookbook(cb, :path => path)
end
