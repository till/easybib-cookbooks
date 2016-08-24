# include_recipe 'php::dependencies-ppa'
# php_ppa_package 'poppler-pdf'

packagecloud_repo 'till/poppler-backport' do
  type 'deb'
end

package 'poppler'
package 'poppler-glib'
package 'php-poppler-pdf'
