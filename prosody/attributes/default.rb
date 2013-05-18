default["prosody"] = {}
default["prosody"]["storage"] = "sql"
default["prosody"]["db"] = {
    "driver" => "MySQL",
    "database" => "prosody",
    "username" => "root",
    "password" => "",
    "hostname" => "127.0.0.1"
}
default["prosody"]["admins"] = ["john@example.org"]
