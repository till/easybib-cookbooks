package_list = node['poppler']['package_list']

package_list.each do |package_name|
  package package_name
end
