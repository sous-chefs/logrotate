if defined?(ChefSpec)
  ChefSpec.define_matcher :logrotate_app

  def enable_logrotate_app(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logrotate_app, :enable, resource)
  end

  def disable_logrotate_app(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:logrotate_app, :disable, resource)
  end
end
