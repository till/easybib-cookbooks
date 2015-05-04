# common library for vagrant-test

require 'json'

require_plugins = [
  'vagrant-cachier',
  'vagrant-faster'
]

require_plugins.each do |plugin_name|
  if Vagrant.has_plugin?(plugin_name)
    puts "Good job, you have #{plugin_name}!"
    next
  end

  puts "Please install #{plugin_name}!"
  exit 1
end

def get_setup_json
  get_json(File.dirname(__FILE__) + '/setup.json')
end

# load and parse .json files
def get_json(file_path)
  JSON.parse(File.read(file_path))
end

# find out where we are
def get_country
  Timeout::timeout(2) {
    info = JSON.parse(Net::HTTP.get_response(URI.parse('http://ip-api.com/json')).body)
    info['countryCode'].downcase
  } rescue 'de'
end

puts get_country
