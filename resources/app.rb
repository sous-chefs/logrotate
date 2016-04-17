resource_name :logrotate_app

property :path, [String, Array], required: true
property :frequency, String, default: "weekly"
property :template_mode, default: "0644"
property :template_owner, default: "root"
property :template_group, default: "root"
property :base_dir, String, default: "/etc/logrotate.d"

property :options, [Array, String], default: %w{missingok compress delaycompress copytruncate notifempty}

default_action :enable

CookbookLogrotate::SCRIPTS.each do |script_name|
  property script_name.to_sym, coerce: Proc.new { |val| Array(val).join("\n") }
end

CookbookLogrotate::VALUES.each do |configurable_name|
  property configurable_name.to_sym
end

# Deprecated options
property :sharedscripts, [TrueClass, FalseClass], default: false
property :enable, [TrueClass, FalseClass], default: true

action :enable do
  if !new_resource.enable
    Chef::Log.deprecation "Use `action :disable` rather than `enable false` in the logrotate_app resource"
    action_disable
    return true
  end

  logrotate_config = {
    # The path should be a space separated list of quoted filesystem paths
    path: Array(new_resource.path).map { |path| path.to_s.inspect }.join(" "),
    frequency: new_resource.frequency,
    directives: handle_options(new_resource),
    scripts: handle_scripts(new_resource),
    configurables: handle_configurables(new_resource),
  }

  directory new_resource.base_dir do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  template "#{new_resource.base_dir}/#{new_resource.name}" do
    source   "logrotate.erb"
    cookbook "logrotate"
    mode     new_resource.template_mode
    owner    new_resource.template_owner
    group    new_resource.template_group
    backup   false
    variables logrotate_config
  end
end

action :disable do
  file "#{new_resource.base_dir}/#{new_resource.name}" do
    action :delete
  end
end

def handle_configurables(new_resource)
  configurables = {}
  CookbookLogrotate::VALUES.each do |opt_name|
    if value = new_resource.send(opt_name.to_sym)
      configurables[opt_name] = value
    end
  end
  configurables
end

def handle_scripts(new_resource)
  scripts = {}
  CookbookLogrotate::SCRIPTS.each do |script_name|
    if script_body = new_resource.send(script_name.to_sym)
      scripts[script_name] = script_body
    end
  end
  scripts
end

def handle_options(new_resource)
  opts = if new_resource.options.is_a?(Array)
           new_resource.options.dup
         else
           new_reosurce.options.split
         end

  if new_resource.sharedscripts
    Chef::Log.deprecation("The sharedscripts resource property is deprecated.  Use the options property instead to set this value")
    opts << "sharedscripts"
  end
  opts
end
