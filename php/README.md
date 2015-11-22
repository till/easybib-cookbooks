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
