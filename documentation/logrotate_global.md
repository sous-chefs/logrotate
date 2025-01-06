# logrotate_global

[Back to resource list](../README.md#resources)

This resource can be used to manage the global logrotate configuration file.

The resource takes the following properties:

## Properties

| Name             | Type          | Default                 | Description                                                     |
| ---------------- | ------------- | ----------------------- | --------------------------------------------------------------- |
| `config_file`    | String        | `'/etc/logrotate.conf'` | Specifies the path to the logrotate global config file.         |
| `template_name`  | String        | `logrotate-global.erb`  | Sets the template source.                                       |
| `template_mode`  | String        | `0644`                  | The mode to create the logrotate config file template.          |
| `template_owner` | String        | `root`                  | The owner of the logrotate config file template.                |
| `template_group` | String        | `node['root_group']`    | The group of the logrotate config file template.                |
| `cookbook`       | String        | `logrotate`             | The cookbook that contains the template source.                 |
| `options`        | String, Array | `%w(weekly dateext)`    | Logrotate global options.                                       |
| `includes`       | String, Array | `[]`                    | Files or directories to include in the logrotate configuration. |
| `parameters`     | Hash          | `{ 'rotate' => 4, 'create' => nil }` | Logrotate global parameters.                      |
| `paths`          | Hash          | `{}`                    | Logrotate global path definitions.                              |
| `scripts`        | Hash          | `{}`                    | Global scripts to run (firstaction, prerotate, postrotate, lastaction). |

## Examples

```ruby
logrotate_global 'logrotate' do
  options %w(create weekly)
  parameters(
    'rotate' => 4
  )
  paths(
    '/var/log/wtmp' => {
      'missingok' => true,
      'monthly' => true,
      'create' => '0664 root utmp',
      'rotate' => 1,
    },
    '/var/log/btmp' => {
      'missingok' => true,
      'monthly' => true,
      'create' => '0600 root utmp',
      'rotate' => 1,
    }
  )
end
```

See the logrotate(8) manual page of v3.9.2 or earlier for the list of available options.
