#
# Cookbook Name:: logrotate
# Attribute:: default
#
# Copyright 2013, Chef Software, Inc
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

default["logrotate"]["package"] = {
  "name" => "logrotate",
  "source" => nil,
  "version" => nil,
  "provider" => nil,
}

default["logrotate"]["directory"] = "/etc/logrotate.d"
default["logrotate"]["cron"]["install"] = platform?("solaris2") || platform?("aix")
default["logrotate"]["cron"]["name"] = "logrotate"
default["logrotate"]["cron"]["command"] = "/usr/sbin/logrotate /etc/logrotate.conf"
default["logrotate"]["cron"]["minute"] = 35
default["logrotate"]["cron"]["hour"] = 2

default["logrotate"]["global"] = {
  "weekly" => true,
  "rotate" => 4,
  "create" => "",

  "/var/log/wtmp" => {
    "missingok" => true,
    "monthly" => true,
    "create" => "0664 root utmp",
    "rotate" => 1,
  },

  "/var/log/btmp" => {
    "missingok" => true,
    "monthly" => true,
    "create" => "0660 root utmp",
    "rotate" => 1,
  },
}
