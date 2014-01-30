#
# Cookbook Name:: puma-test
# Recipe:: default
#

node.set['poise-ruby']['ruby'] = 'ruby-200'
node.set['puma']['rubygems_location'] = '/opt/ruby-200/bin/gem'

include_recipe 'build-essential'
include_recipe 'poise-ruby'

poise_ruby 'ruby-200' do
  version '2.0.0-p353'
end

gem_package 'bundler' do
  gem_binary '/opt/ruby-200/bin/gem'
end

file '/etc/profile.d/ruby.sh' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  content 'export PATH="$PATH:/opt/ruby-200/bin"'
end

include_recipe 'puma'
