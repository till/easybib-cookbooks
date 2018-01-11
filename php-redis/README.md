# php-redis-cookbook

Chef cookbook to download and install the PHP extension redis - https://github.com/nicolasff/phpredis


## Attributes

```
node['php_redis']['url'] = 'https://github.com/nicolasff/phpredis/archive/master.tar.gz'
```

## Usage

### php-redis::default

Include `php-redis` in your node's `run_list`. This will download and install redis.

```json
{
  "run_list": [
    "recipe[php-redis::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request
