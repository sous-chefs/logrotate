name              'logrotate'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs logrotate package and provides a resource for managing logrotate configs'
version           '2.2.3'

%w(amazon centos debian fedora redhat scientific solaris2 ubuntu suse opensuseleap).each do |platform|
  supports platform
end

source_url 'https://github.com/chef-cookbooks/logrotate'
issues_url 'https://github.com/chef-cookbooks/logrotate/issues'
chef_version '>= 12.15'
