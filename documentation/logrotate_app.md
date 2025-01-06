# logrotate_app

[Back to resource list](../README.md#resources)

This resource can be used to drop off customized logrotate config files on a per application basis.

The resource takes the following properties:

## Properties

| Name             | Type          | Default     | Description                                                                                                                                 |
| ---------------- | ------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `path`           | String, Array | `nil`       | Specifies a single path (string) or multiple paths (array) that should have logrotation stanzas created in the config file.                 |
| `cookbook`       | String        | `node['root_group']` | The cookbook that continues the template for logrotate_app config resources.                                                                |
| `template_name`  | String        | `logrotate.erb` | Sets the template source.                                                                                                                   |
| `template_mode`  | String        | `0644` | The mode to create the logrotate template.                                                                                                  |
| `template_owner` | String        | `root` | The owner of the logrotate template.                                                                                                        |
| `template_group` | String        | `root` | The group of the logrotate template.                                                                                                        |
| `frequency`      | String        | `weekly` | Sets the frequency for rotation. Valid values are: hourly, daily, weekly, monthly, yearly, see the logrotate man page for more information. |
| `options`        | String, Array | `%w(missingok compress delaycompress copytruncate notifempty)` | Any logrotate configuration option that doesn't specify a value. See the logrotate(8) manual page of v3.9.2 or earlier for details. |
| `base_dir`       | String        | `/etc/logrotate.d` | The base directory where the logrotate configuration files will be stored. |
| `firstaction`    | String, Array | `nil` | Script to run before log files are rotated |
| `prerotate`      | String, Array | `nil` | Script to run before individual log file is rotated |
| `postrotate`     | String, Array | `nil` | Script to run after individual log file is rotated |
| `lastaction`     | String, Array | `nil` | Script to run after all log files are rotated |

## Examples

In addition to the above properties, any logrotate option that takes a parameter can be used as a logrotate_app property. For example, to set the `rotate` option you can use a resource declaration such as:

```ruby
logrotate_app 'tomcat-myapp' do
  path      '/var/log/tomcat/myapp.log'
  frequency 'daily'
  rotate    30
  create    '644 root adm'
end
```

Also, any logrotate option that takes one of scripts names (`firstaction`, `prerotate`, `postrotate`, and `lastaction`) can be used. Script body should be passed as value of this option. For example, nginx logrotation with `postrotate`:

```ruby
logrotate_app 'nginx' do
  path      '/var/log/nginx/*.log'
  frequency 'daily'
  options %w(missingok compress delaycompress notifempty dateext dateyesterday nomail sharedscripts)
  rotate 365
  create '640 www-data www-data'
  dateformat '.%Y-%m-%d'
  maxage 365
  postrotate '[ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`'
end
```

See the logrotate(8) manual page of v3.9.2 or earlier for the list of available options.
