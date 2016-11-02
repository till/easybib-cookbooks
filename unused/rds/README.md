# RDS backup to S3 system

This can do backups of several servers at once, so you have to configure it in the attributes like this:

    default["rdsbackup"] = [ { "jobname" => "db1 backup",
                               "prefix" => "back1",
                               "sqlhost" => "db1.example.com",
                               "sqluser" => "sara",
                               "sqlpass" => "letmein",
                               "s3bucket" => "qweyuqyeu",
                               "s3accesskeyid" => "daghagha",
                               "s3secretaccesskey" => "zcxcbznc",
                               "cronminute" => "37",
                               "cronhour" => "13",
                               "cronweekday" => "*" } ,
                             { "jobname" => "db2 backup",
                               "prefix" => "back2",
                               "sqlhost" => "db2.example.com",
                               "sqluser" => "bill",
                               "sqlpass" => "password1",
                               "s3bucket" => "eryueryu",
                               "s3accesskeyid" => "fgjhfghjd",
                               "s3secretaccesskey" => "cvbncvbn",
                               "cronminute" => "54",
                               "cronhour" => "*",
                               "cronweekday" => "*" } ]

The _jobname_ is the name of the cron job, _prefix_ is the prefix for the generated filenames, _sql\*_ is the connection data for the
MySQL servers (all databases on each server will be backed up), _s3\*_ is the connection data for Amazon S3, and _cron\*_ is the
configuration information for cron.
