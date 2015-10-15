set_unless['postfix']            = {}
set_unless['postfix']['relay']   = { 'user' => 'foo@example.org', 'pass' => 'test123', 'host' => nil }
set_unless['postfix']['aliases'] = %w(postmaster mailer-daemon www-data)
