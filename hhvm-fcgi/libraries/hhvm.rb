module Hhvm
  def get_complete_path(path, node = self.node)
    "#{node["hhvm-fcgi"]["prefix"]}#{path}"
  end
end

class Chef::Recipe
  include Hhvm
end
