name 'nginx-trust-cert'
maintainer 'Flame Herbohn'
maintainer_email 'flame.herbohn@imagineeasy.com'
license 'BSD License'
description 'Trust the nginx cert for local testing'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.1'
supports 'ubuntu', '>= 12.04'

depends 'nginx-app'
