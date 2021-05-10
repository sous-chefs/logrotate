# logrotate Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/logrotate.svg)](https://supermarket.chef.io/cookbooks/logrotate)
[![CI State](https://github.com/sous-chefs/logrotate/workflows/ci/badge.svg)](https://github.com/sous-chefs/logrotate/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Manages the logrotate package and provides a resource to manage application specific logrotate configuration.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit sous-chefs.org or come chat with us on the Chef Community Slack in #sous-chefs.

## Requirements

### Platforms

Should work on any platform that includes a 'logrotate' package and writes logrotate configuration to /etc/logrotate.d.

Tested on:

- Ubuntu / Debian
- CentOS
- Amazon Linux
- openSUSE Leap

### Chef

- Chef 12.5+

## Resources

- [logrotate_app](documentation/logrotate_app.md)
- [logrotate_global](documentation/logrotate_global.md)
- [logrotate_package](documentation/logrotate_package.md)

## Usage

The package resource will ensure logrotate is always up to date by default.

To create application specific logrotate configs, use the `logrotate_app` resource. For example, to rotate logs for a tomcat application named myapp that writes its log file to `/var/log/tomcat/myapp.log`:

```ruby
logrotate_app 'tomcat-myapp' do
  path      '/var/log/tomcat/myapp.log'
  frequency 'daily'
  rotate    30
  create    '644 root adm'
end
```

To rotate multiple logfile paths, specify the path as an array:

```ruby
logrotate_app 'tomcat-myapp' do
  path      ['/var/log/tomcat/myapp.log', '/opt/local/tomcat/catalina.out']
  frequency 'daily'
  create    '644 root adm'
  rotate    7
end
```

To specify which logrotate options, specify the options as an array:

```ruby
logrotate_app 'tomcat-myapp' do
  path      '/var/log/tomcat/myapp.log'
  options   ['missingok', 'delaycompress', 'notifempty']
  frequency 'daily'
  rotate    30
  create    '644 root adm'
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
