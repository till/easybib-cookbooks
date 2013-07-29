module XHProf

  def get_path(node = self.node)
    if node["xhprof.io"]
      uri = URI(node["xhprof.io"]["url"])
      return uri.path.gsub(/[#{Regexp.escape("/")}]+$/, '')
    end
    return "/xhprof"
  end

  def get_dsn(node = self.node)
    conf = node["xhprof.io"]
    return "mysql:dbname=#{conf["dbname"]};host=#{conf["host"]}"
  end

  extend self
end

class Chef::Recipe
  include XHProf
end
