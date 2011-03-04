set_unless[:jenkins][:port]  = 8080
set_unless[:jenkins][:domain]  = "jenkins.codebox"
set_unless[:jenkins][:git_user_name]  = "jenkins"
set_unless[:jenkins][:plugins]  = {"checkstyle" => "latest", 
                                    "clover" => "latest", 
                                    "dry" => "latest", 
                                    "htmlpublisher" => "latest",
                                    "jdepend" => "latest", 
                                    "plot" => "latest", 
                                    "pmd" => "latest", 
                                    "violations" => "latest", 
                                    "xunit" => "latest",
                                    "git" => "latest", 
                                    "github" => "latest"}
set_unless[:jenkins][:apt_repository]  = "jenkins-ci"

set_unless[:php_pear][:channels]  =  ["pear.pdepend.org",
                                      "pear.phpmd.org",
                                      "pear.phpunit.de",
                                      "components.ez.no",
                                      "pear.symfony-project.com"]
set_unless[:php_pear][:packages]  =  ["pdepend/PHP_Depend-beta",
                                      "phpmd/PHP_PMD-alpha",
                                      "phpunit/phpcpd",
                                      "phpunit/phploc",
                                      "PHPDocumentor",
                                      "PHP_CodeSniffer",
                                      "--alldeps phpunit/PHP_CodeBrowser",
                                      "--alldeps phpunit/PHPUnit", 
                                      "Mail", "Mail_Mime", "DB", "MDB2",  #for mail_queue
                                      "--force Net_URL2", #for http_request2
                                      ]


set_unless[:buildconfigs][:configs]  =  ["Mail_Queue", "HTTP_Request2", "Net_CheckIP2", "net_gearman", "Rediska", "Services_Amazon_S3"]