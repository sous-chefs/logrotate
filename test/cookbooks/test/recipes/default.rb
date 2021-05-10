logrotate_package ''

2.times { |t| file "/var/log/global_log_#{t}" }

include_recipe '::global'
include_recipe '::app'
