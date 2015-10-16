set_unless['postfix']            = {}
# host is just hostname, full_host is used as relayhost setting, so e.g. "[foo.com]:578"
set_unless['postfix']['relay']   = { 'user' => 'foo@example.org', 'pass' => 'test123', 'host' => nil, 'full_host' => nil }
set_unless['postfix']['aliases'] = %w(postmaster mailer-daemon www-data)
# if true: rewrites all from addresses to sysadmin_mail
set_unless['postfix']['rewrite_address'] = true
