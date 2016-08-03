# IES MySQL Tuning-Primer

This is a customized version of https://launchpad.net/mysql-tuning-primer/trunk. It is stripped of all
the features we don't need and on the other side able to connect to MySQL via TCP. It is designed to
simply use whatever is stated in the `~/.my.cnf` or fail.

# Usage
Find an instance that is able to connect to the RDS you wish to profile. Go to that instance's stack's
dashboard and run the command 'Execute Recipes'. Configure the recipe
`ies-mysql-tuning-primer::default` to run on the instance you've investigated. This will deploy the
primer script under `/usr/local/bin/ies-mysql-tuning-primer.sh`.

SSH onto the instance, create `~/.my.cnf'...

```
[client]
user = 
password = 
hostname = 
```

... end fill out the blanks.

Finally, execute the script:
```
ies-mysql-tuning-primer.sh
```
