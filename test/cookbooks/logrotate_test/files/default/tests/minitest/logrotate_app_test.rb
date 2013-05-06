#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require File.expand_path('../support/helpers', __FILE__)

describe 'logrotate::logrotate_app' do
  include Helpers::Logrotate

  it 'creates a basic template for tomcat-myapp' do
    file('/etc/logrotate.d/tomcat-myapp').must_match(/^\/var\/log\/tomcat\/myapp.log/)
  end

  describe 'creates a template for tomcat-myapp with multiple paths' do
    let(:config) { file('/etc/logrotate.d/tomcat-myapp-multi-path') }
    it { config.must_match(/^\/var\/log\/tomcat\/myapp.log/) }
    it { config.must_match(/^\/opt\/local\/tomcat\/catalina\.out/) }
  end

  it 'creates a template for tomcat-myapp without the create line' do
    file('/etc/logrotate.d/tomcat-myapp-no-create').wont_match(/  create/)
  end

  it 'creates a template from an alternative cookbook' do
    file('/etc/logrotate.d/tomcat-myapp-alt-cookbook').must_match(/# From an alternate cookbook/)
  end

  describe 'uses the options passed to the definition' do
    let(:config) { file('/etc/logrotate.d/tomcat-myapp-cook-1338') }
    it { config.must_match(/missingok/) }
    it { config.must_match(/delaycompress/) }
    it { config.wont_match(/notifempty/) }
  end

  describe 'generates a script that is passed in' do
    let(:config) { file('/etc/logrotate.d/tomcat-myapp-cook-2872') }
    it { config.must_match(/firstaction/) }
    it { config.must_match(/lastaction/) }
    it { config.must_match(/echo 'firstaction'/) }
    it { config.must_match(/echo 'lastaction'/) }
  end

end
