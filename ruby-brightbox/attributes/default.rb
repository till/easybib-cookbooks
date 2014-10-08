default['ruby-brightbox'] = {}
default['ruby-brightbox']['version'] = '1.9.1'

if (node["lsb"]["codename"] == "trusty" and node["ppa"]["enable_trusty_mirror"])
  default['ruby-brightbox']['ppa'] = 'http://ppa.ezbib.com/trusty55'
else
  default['ruby-brightbox']['ppa'] = 'ppa:brightbox/ruby-ng'
end
