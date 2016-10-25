name              "logrotate"
maintainer        "Steven Danna"
maintainer_email  "steve@chef.io"
license           "Apache 2.0"
description       "Installs logrotate package and provides a definition for logrotate configs"
long_description  "Installs the logrotate package, manages /etc/logrotate.conf, and provides a logrotate_app definition."
version           "2.1.0"

source_url "https://github.com/stevendanna/logrotate"
issues_url "https://github.com/stevendanna/logrotate/issues"
chef_version ">= 12.1" if respond_to?(:chef_version)

recipe "logrotate", "Installs logrotate package"
provides "logrotate_app"

depends "compat_resource", ">= 12.14.7"

%w{amazon centos debian fedora redhat scientific solaris2 ubuntu}.each do |platform|
  supports platform
end
