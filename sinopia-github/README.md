# Cookbook for Sinopia-Github

##DESCRIPTION:
This cookbook adds the sinopia github project to a sinopia setup

##REQUIREMENTS:
This cookbook depends on https://github.com/rlidwka/sinopia
This cookbook depends on https://github.com/mattfysh/sinopia-github

##USAGE:
it's an NPM repo
web interface is here prolly: http://vagrant:4873/ - use your github credentials to login
when you want to publish your npm packages to it you do something like:
npm set registry http://vagrant:4873
npm adduser --registry http://vagrant:4873
when adduser asks you for credentials... 
username == github username (not the email addr)
password == github password
email(optional) == github email address (not really optional)

###Example deploy.json

```
{
  "sinopia": {
    "user": "root",
    "listen": "0.0.0.0:4873"
  },
  "sinopia-github": {
    "install_path": "/usr/lib/node_modules/sinopia/node_modules/",
    "auth": {
      "type": "github",
      "org": "github_org",
      "client_id": "github_client_id",
      "client_secret": "github_client_secret",
      "ttl": "300"
    }
  }
}
```

