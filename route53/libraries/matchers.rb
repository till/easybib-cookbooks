# ChefSpec matcher for route53 Cookbook.
#
# Library:: matchers
# Cookbook Name:: route53
# Author:: Greg Albrecht (gba@onbeep.com)
#


if defined?(ChefSpec)
  def create_route53_record(name)
    ChefSpec::Matchers::ResourceMatcher.new(:route53_record, :create, name)
  end

  def delete_route53_record(name)
    ChefSpec::Matchers::ResourceMatcher.new(:route53_record, :delete, name)
  end
end
