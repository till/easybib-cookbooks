if node["prosody"]["storage"] == "sql"

  db_conf = node["prosody"]["db"]

  driver = db_conf["driver"].downcase

  package "Installing DBI bindings for '#{driver}'" do
    package_name "lua-dbi-#{driver}"
  end

  case driver
  when "mysql"
    mysql_command = "mysql -u %s -h %s" % [ db_conf["username"], db_conf["hostname"] ]
    if !db_conf["password"].empty?
      mysql_command += " -p#{db_conf["password"]}"
    end

    execute "create database '#{db_conf["database"]} for prosody" do
      command "#{mysql_command} -e \"CREATE DATABASE IF NOT EXISTS #{db_conf["database"]}\""
    end
  when "postgresql"
    # this needs to be done
    Chef::Log.info("Haven't do this yet.")
  when "sqlite3"
    # this should just work :)
  else
    Chef.Log::Error("The '#{driver}' is not yet supported.")
  end

end
