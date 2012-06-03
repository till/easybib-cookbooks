# php_composer

 * actions: `:setup`, `:install`
 * `:install`: runs `php composer.phar install`
 * `:setup`: installs the `composer.phar`

## Example

    php_composer "/tmp" do
      action [:setup, :install]
    end

Note: the example requires that there is a `composer.json` file in `/tmp`.

On top of that, composer needs a couple utilities installed an in path. Please see my `vagrant-test::default` recipe.

# php_pear

 * actions: `:install`, `:install_if_missing`, `:uninstall`, `:upgrade`
 * attributes: `channel`, `force`, `version`

## Example

    php_pear "EasyBib_Form_Decorator" do
      action  :install_if_missing
      channel "easybib.github.com/pear"
      force   true
      version "0.3.2"
    end

# php_pecl

This resource is a heavy WIP since it contains a couple hard-coded paths, which may or may not be what they are on your system.

 * actions: `:install`, `:setup`
 * `:install`: runs `pecl install foo`
 * `:setup`: creates an `extension.ini`

## Example

    php_pecl "memache" do
      action [:install, :setup]
    end
