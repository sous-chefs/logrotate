#
# Cookbook Name:: logrotate
# Recipe:: default
#
# Copyright 2009-2013, Chef Software, Inc.
# Copyright 2015-2016, Steven Danna
# Copyright 2016, Bloomberg Finance L.P.
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
return if platform?("windows")

package node["logrotate"]["package"]["name"] do
  provider node["logrotate"]["package"]["provider"] if node["logrotate"]["package"]["provider"]
  source node["logrotate"]["package"]["source"] if node["logrotate"]["package"]["source"]
  version node["logrotate"]["package"]["version"] if node["logrotate"]["package"]["version"]
  action :upgrade
end

directory node["logrotate"]["directory"] do
  owner "root"
  group node["root_group"]
  mode "0755"
end

if node["logrotate"]["cron"]["install"] # ~FC023
  cron node["logrotate"]["cron"]["name"] do
    minute node["logrotate"]["cron"]["minute"]
    hour node["logrotate"]["cron"]["hour"]
    command node["logrotate"]["cron"]["command"]
  end
end
