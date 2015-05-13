# Cookbook for Sinopia-Github

##DESCRIPTION:
This cookbook adds the sinopia github project to a sinopia setup

##REQUIREMENTS:
This cookbook depends on https://github.com/rlidwka/sinopia
This cookbook depends on https://github.com/mattfysh/sinopia-github

##USAGE:
Add a data_bag to `npm_packages/` called `packages.json`. This data_bag lists
the packages that you want installed by `npm`.

###Example data_bag

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

