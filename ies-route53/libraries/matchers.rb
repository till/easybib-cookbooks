if defined?(ChefSpec)
  def create_ies_route53_record(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ies_route53_record, :create, resource_name)
  end
end
