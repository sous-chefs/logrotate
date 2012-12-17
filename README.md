Logrotate Cookbook
==================
Manages the `logrotate` package and provides a definition to manage application-specific `logrotate` configuration.

Requirements
------------
Works on any platform that includes a `logrotate` package and writes `logrotate` configuration to `/etc/logrotate.d`. Tested on Ubuntu, Debian and Red Hat/CentOS.

Definitions
-----------
### logrotate\_app
This definition can be used to drop off customized logrotate config files on a per application basis.

#### Attributes
<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Example</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>path</td>
    <td>specifies a path paths that should have logrotation stanzas created in the config file</td>
    <td><tt>/var/myapp/application.log</tt></td>
    <td></td>
  </tr>
  <tr>
    <td>enable</td>
    <td>create the template in <tt>/etc/logrotate.d</tt></td>
    <td><tt>true</tt></td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td>frequency</td>
    <td>sets the frequency for rotation. Valid values are: daily, weekly, monthly, yearly, see the logrotate man page for more information.</td>
    <td><tt>'monthly'</tt></td>
    <td><tt>'weekly'</tt></td>
  </tr>
  <tr>
    <td>template</td>
    <td>the template sournce</td>
    <td><tt>'/var/myapp/logrotate.erb'</tt></td>
    <td><tt>'logrotate.erb'</tt></td>
  </tr>
  <tr>
    <td>cookbook</td>
    <td>select the template source from the specified cookbook</td>
    <td><tt>my_app</tt></td>
    <td><tt>logrotate</tt></td>
  </tr>
  <tr>
    <td>create</td>
    <td>creation parameters for the logrotate "create" config; follows the form "mode owner group"</td>
    <td><tt>'644 root root'</tt></td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td>prerotate</td>
    <td>executed after the log file is rotated</td>
    <td><tt></tt></td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td>postrotate</td>
    <td>executed after the log file is rotated</td>
    <td><tt></tt></td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td>sharedscripts</td>
    <td>the sharedscripts options is specified which makes sure prescript and postscript commands are run only once (even if multiple files match the path)</td>
    <td><tt>true</tt></td>
    <td><tt>false</tt></td>
  </tr>
</table>

Usage
------
The default recipe will ensure the `logrotate` package is always up to date.

To create application specific `logrotate` configurations, use the `logrotate_app` definition.

```ruby
# Rotate a tomcat application named 'myapp'
logrotate_app 'tomcat-myapp' do
  cookbook      'logrotate'
  path          '/var/log/tomcat/myapp.log'
  frequency     'daily'
  rotate        30
  create        '644 root adm'
end
```

```ruby
# Rotate multiple logfile paths using an array
logrotate_app 'tomcat-myapp' do
  cookbook        'logrotate'
  path            [ '/var/log/tomcat/myapp.log', '/opt/local/tomcat/catalina.out' ]
  frequency       'daily'
  create          '644 root adm'
  rotate          7
end
```

```ruby
# Specify logrotate options
logrotate_app 'tomcat-myapp' do
  cookbook        'logrotate'
  path            '/var/log/tomcat/myapp.log'
  options         [ 'missingok', 'delaycompress', 'notifempty' ]
  frequency       'daily'
  rotate          30
  create          '644 root adm'
end
```

License and Author
------------------
- Author:: Scott M. Likens (<scott@likens.us>)
- Author:: Joshua Timberman (<joshua@opscode.com>)

- Copyright:: 2009, Scott M. Likens
- Copyright:: 2011-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
