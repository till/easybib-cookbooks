set_unless["postfix"]            = {}
set_unless["postfix"]["relay"]   = [{"user" => "foo@example.org", "pass" => "test123", "host" => "example.org"}]
set_unless["postfix"]["aliases"] = ['postmaster', 'root']
set_unless["sysop_email"]        = 'foo@example.org'
