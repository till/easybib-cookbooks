default['aptly']                 = {}
default['aptly']['mirror_name']  = 'easybib_ppa'
default['aptly']['s3_mirror']    = 'easybib_ppa'
default['aptly']['s3_mirror_prefix'] = 'prefix'
default['aptly']['mirror_dir']   = '/tmp/ppa'
default['aptly']['sign_pass']    = 'heythere'
default['aptly']['gpgkeys']      = %w(66E3A9B7 63561DC6 5D50B6BA C7917B12 06ED541C C3173AA6 B6AC7E8C 0737E5F5 E93F5328)
