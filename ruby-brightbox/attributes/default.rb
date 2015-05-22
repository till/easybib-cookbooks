default['ruby-brightbox'] = {}
default['ruby-brightbox']['version'] = '1.9.1'
default['ruby-brightbox']['ppa'] = ::EasyBib::Ppa.ppa_mirror(node, 'ppa:brightbox/ruby-ng')
