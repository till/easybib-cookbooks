module EasyBib
  module Php
    def to_php_yaml(obj)
      # This is an ugly quick hack: Ruby Yaml adds object info !map:Chef::Node::ImmutableMash which
      # the Symfony Yaml parser doesnt like. So lets remove it. First Chef 11.4/Ruby 1.8,
      # then Chef 11.10/Ruby 2.0
      yaml    = YAML.dump(obj)
      content = yaml.gsub('!map:Chef::Node::ImmutableMash', '')
      content.gsub('!ruby/hash:Chef::Node::ImmutableMash', '')
    end
  end
end
