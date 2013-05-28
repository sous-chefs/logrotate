#
# Cookbook Name:: logrotate_test
# Recipe:: logrotate_app
#
# Copyright 2012, Opscode, Inc.
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
include_recipe "logrotate::default"

logrotate_app "tomcat-myapp" do
  path "/var/log/tomcat/myapp.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
end

logrotate_app "tomcat-myapp-multi-path" do
  path [ "/var/log/tomcat/myapp.log", "/opt/local/tomcat/catalina.out" ]
  frequency "daily"
  create "644 root adm"
  rotate 7
end

logrotate_app "tomcat-myapp-no-create" do
  path "/var/log/tomcat/myapp.log"
  frequency "daily"
  rotate 30
end

logrotate_app "tomcat-myapp-alt-cookbook" do
  cookbook "logrotate_test"
  path "/var/log/tomcat/myapp.log"
  frequency "daily"
  rotate 30
end

logrotate_app "tomcat-myapp-cook-1338" do
  path "/var/log/tomcat/myapp.log"
  options ["missingok", "delaycompress"]
  frequency "daily"
  rotate 30
  create "644 root adm"
end

logrotate_app "tomcat-myapp-cook-2872" do
  path "/var/log/tomcat/myapp.log"
  frequency "daily"
  rotate 30
  create "644 root adm"
  firstaction "echo 'firstaction'"
  lastaction "echo 'lastaction'"
end

logrotate_app "tomcat-myapp-cook-2908" do
  path "/var/log/tomcat/myapp.log"
  enable false
end
