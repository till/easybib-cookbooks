default['easybib_deploy'] = {
	'gearman_file' => 'pecl_manager_env',
	'env_source' => nil,
	'provide_pear' => false,
	'cron_path' => '/usr/local/bin:/usr/bin:/bin',
	'use_newrelic' => 'no',
	'envtype' => 'playground',
	'cronjob_role' => nil
}

default['easybib']['enable_ppa_mirror']  = false
default['easybib']['php_mirror_version'] = '55'
