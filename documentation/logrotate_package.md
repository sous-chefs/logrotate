# logrotate_package

[Back to resource list](../README.md#resources)

Manages the installation of the logrotate package. This resource allows you to install, upgrade, or remove the logrotate package and its dependencies.

Introduced: v3.0.0

## Actions

- `:upgrade` - Upgrade the logrotate package if a newer version is available
- `:install` - Install the logrotate package (default)
- `:remove` - Remove the logrotate package

## Properties

| Name       | Type          | Default       | Description                               |
| ---------- | ------------- | ------------- | ----------------------------------------- |
| `packages` | String, Array | `'logrotate'` | Package name or array of package names to manage |

## Examples

Basic installation using defaults:

```ruby
logrotate_package 'logrotate'
```

Install a specific package:

```ruby
logrotate_package 'logrotate' do
  packages 'logrotate-special-package'
end
```

Install multiple packages:

```ruby
logrotate_package 'logrotate' do
  packages ['logrotate', 'logrotate-dbg']
end
```

Upgrade existing installation:

```ruby
logrotate_package 'logrotate' do
  action :upgrade
end
```

Remove logrotate:

```ruby
logrotate_package 'logrotate' do
  action :remove
end
