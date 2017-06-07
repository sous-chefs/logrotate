require 'spec_helper'

describe 'logrotate::global' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'includes the default recipe' do
    expect(chef_run).to include_recipe('logrotate::default')
  end

  it 'writes the configuration template' do
    template = chef_run.template('/etc/logrotate.conf')
    expect(template).to be
    expect(template.source).to eq('logrotate-global.erb')
    expect(template.mode).to eq('0644')
  end

  shared_examples 'script in global context' do
    it 'puts the script in the configuration file' do
      expect(chef_run).to render_file('/etc/logrotate.conf').with_content(content_regexp)
    end
  end

  %w(postrotate prerotate firstaction lastaction).each do |script_type|
    context "when a #{script_type} script is present in the global attribute" do
      let(:script) { "/usr/bin/test_#{script_type}_script" }
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.override['logrotate']['global'][script_type] = script
        end.converge(described_recipe)
      end
      let(:content_regexp) { /#{script_type}\n#{script}\nendscript/ }

      it_behaves_like 'script in global context'
    end
  end
end
