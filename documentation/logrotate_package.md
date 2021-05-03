# logrotate_package

[Back to resource list](../README.md#resources)

Install logrotate from package.

Introduced: v3.0.0

## Actions

- `:install`
- `:upgrade`
- `:remove`

## Properties

| Name       | Type          | Default       | Description                               |
| ---------- | ------------- | ------------- | ----------------------------------------- |
| `packages` | String, Array | `'logrotate'` | List of packages to install for logrotate |

## Examples

```ruby
logrotate_package 'logrotate'
```

```ruby
logrotate_package 'logrotate' do
  packages 'logrotate-special-package'
end
```
