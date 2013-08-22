if !node["prosody"]["users"].empty?
  node["prosody"]["users"].each do |email,passwd|

    Chef::Log.debug("Email: #{email}")

    account = email.split("@")[0]
    domain  = email.split("@")[1]

    if !node["prosody"]["domains"].include?(domain)
      Chef::Log.error("Domain for #{email} is not managed by this server.")
      next
    end
    
    package "expect"

    execute "add user: #{email}" do
      #prosodyctl register would overwrite an existing user, while 
      #prosodyctl adduser does not accept the password as a param.
      #Using expect as a workaround.
      command "expect -c 'spawn /usr/bin/prosodyctl adduser #{email}
       expect \"Enter new password:\"
       send \"#{passwd}\\r\"
       expect \"Retype new password:\" 
       send \"#{passwd}\\r\"
       expect eof'"
    end

  end
end

if node["prosody"]["storage"] == "sql"

  db_conf = node["prosody"]["db"]
  driver  = db_conf["driver"].downcase

  case driver
  when "mysql"
    mysql_command = "mysql -u %s -h %s" % [ db_conf["username"], db_conf["hostname"] ]
    if !db_conf["password"].empty?
      mysql_command += " -p#{db_conf["password"]}"
    end

    if !node["prosody"]["users"].empty?
      
      userstatement = " NOT ("      
      node["prosody"]["users"].each do |email,passwd|

        Chef::Log.debug("Email: #{email}")

        account = email.split("@")[0]
        domain  = email.split("@")[1]
        
        userstatement += " ( host='#{domain}' AND user='#{account}') OR "

      end            
      userstatement = userstatement[0..-4] #cut the last OR

      Chef::Log.debug("I am going to delete prosody users where: #{userstatement} ")
      
      execute "delete other accounts" do
        command "#{mysql_command} -e \"DELETE FROM #{db_conf["database"]}.prosody WHERE store='accounts' AND #{userstatement}) \""
      end

    end

  else
    Chef::Log.error("Unsupport!")
  end

end
