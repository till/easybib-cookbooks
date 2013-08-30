default["prosody"] = {}
default["prosody"]["admins"] = []
default["prosody"]["storage"] = "sql"
default["prosody"]["db"] = {
  "driver" => "MySQL",
  "database" => "prosody",
  "username" => "root",
  "password" => "",
  "hostname" => "127.0.0.1"
}
default["prosody"]["domains"] = []
default["prosody"]["admins"] = ["john@example.org"]
default["prosody"]["users"] = {}
default["prosody"]["groups"] = {}
default["prosody"]["conferences"] = {}
