#
# Cookbook:: logrotate
# Resource:: app
#
# Copyright:: 2016-2019, Steven Danna
# Copyright:: 2009-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true

include ::Logrotate::Cookbook::LogrotateHelpers

property :path, [String, Array],
          coerce: proc { |p| Array(p).sort.map { |path| path.to_s.inspect }.join(' ') }

property :frequency, String,
          default: 'weekly'

property :cookbook, String,
          default: 'logrotate'

property :template_name, String,
          default: 'logrotate.erb'

property :template_mode, String,
          default: '0644'

property :template_owner, String,
          default: 'root'

property :template_group, String,
          default: 'root'

property :base_dir, String,
          default: '/etc/logrotate.d'

property :options, [String, Array],
          default: %w(missingok compress delaycompress copytruncate notifempty),
          coerce: proc { |p| options_from(p.is_a?(Array) ? p : p.split) }

::Logrotate::Cookbook::LogrotateHelpers::SCRIPTS.each { |script_name| property(script_name.to_sym, coerce: proc { |p| Array(p).join("\n    ") }) }

::Logrotate::Cookbook::LogrotateHelpers::PARAMETERS.each { |configurable_name| property(configurable_name.to_sym) }

action_class do
  include ::Logrotate::Cookbook::LogrotateHelpers

  def required_properties_set?
    raise Chef::Exceptions::ValidationFailed, 'path is a required property' unless action.eql?(:delete) || !new_resource.path.nil?
  end

  def handle_parameters(new_resource)
    ::Logrotate::Cookbook::LogrotateHelpers::PARAMETERS.map do |parameter_name|
      [ parameter_name, new_resource.send(parameter_name.to_sym) ] if new_resource.send(parameter_name.to_sym)
    end.compact.to_h
  end

  def handle_scripts(new_resource)
    ::Logrotate::Cookbook::LogrotateHelpers::SCRIPTS.map do |script_name|
      [ script_name, new_resource.send(script_name.to_sym) ] if new_resource.send(script_name.to_sym)
    end.compact.to_h
  end
end

action :enable do
  required_properties_set?

  directory new_resource.base_dir do
    owner 'root'
    group node['root_group']
    mode '0755'
    action :create
  end

  template "#{new_resource.base_dir}/#{new_resource.name}" do
    cookbook new_resource.cookbook
    source new_resource.template_name

    mode new_resource.template_mode
    owner new_resource.template_owner
    group new_resource.template_group

    sensitive new_resource.sensitive

    variables(
      path: new_resource.path,
      frequency: new_resource.frequency,
      options: new_resource.options,
      scripts: handle_scripts(new_resource),
      parameters: handle_parameters(new_resource)
    )

    helpers(Logrotate::Cookbook::TemplateHelpers)

    action :create
  end
end

action :disable do
  file "#{new_resource.base_dir}/#{new_resource.name}" do
    action :delete
  end
end
