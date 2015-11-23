default['easybib_deploy']                  = {}
default['easybib_deploy']['gearman_file']  = 'pecl_manager_env'
default['easybib_deploy']['env_source']    = nil
default['easybib_deploy']['provide_pear']  = false
default['easybib_deploy']['cron_path']     = '/usr/local/bin:/usr/bin:/bin'
default['easybib_deploy']['use_newrelic']  = 'no'
default['easybib_deploy']['envtype']       = 'playground'
default['easybib_deploy']['cronjob_role']  = nil
default['easybib_deploy']['supervisor_role'] = 'consumer'
default['easybib']['enable_ppa_mirror']  = false
default['easybib']['php_mirror_version'] = '55'
default['easybib']['sns']['topic_arn']   = nil
# notify via sns if hostname contains this string:
default['easybib']['sns']['notify_spinup'] = '-load'
