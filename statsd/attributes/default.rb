set_unless[:librato]                     = {}
set_unless[:librato][:node]              = {}
set_unless[:librato][:node][:user]       = 'root'
set_unless[:librato][:node][:group]      = 'root'
set_unless[:librato][:metrics]           = {}
set_unless[:librato][:metrics][:email]   = 'foo@example.org'
set_unless[:librato][:metrics][:api_key] = '123'
