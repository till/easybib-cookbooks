maintainer        "Peritor GmbH"
maintainer_email  "scalarium@peritor.com"
license           "Apache 2.0"
description       "Installs and configures CouchDB server with the database running off an EBS volume."
version           "0.1"
recipe            "couchdb::server", "Installs CouchDB"
recipe            "couchdb::prepare", "Creates prequesites like user and directories"

supports 'ubuntu'