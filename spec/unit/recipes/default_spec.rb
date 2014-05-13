require 'spec_helper'

describe 'puma::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs the puma gem' do
    expect(chef_run).to install_gem_package('puma').with(version: '2.8.2')
  end

  it 'installs the bundler gem' do
    expect(chef_run).to install_gem_package('bundler').with(version: '1.6.2')
  end
end
