logrotate_package ''

directory ::Logrotate::Cookbook::LogrotateHelpers::lr_path('/var/log') do
  action :create
  recursive true
end

directory ::Logrotate::Cookbook::LogrotateHelpers::lr_path('/etc') do
  action :create
  recursive true
end

2.times { |t| file ::Logrotate::Cookbook::LogrotateHelpers::lr_path("/var/log/global_log_#{t}") }

include_recipe '::global'
include_recipe '::app'
