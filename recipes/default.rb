# Cookbook Name:: puma
# Recipe:: default
#
# Copyright 2013, Yousef Ourabi
#

gem_package 'bundler' do
  version node['bundler']['version']
  gem_binary node['puma']['rubygems_location']
  options '--no-ri --no-rdoc'
  action :install
end

gem_package 'puma' do
  version node['puma']['version']
  gem_binary node['puma']['rubygems_location']
  options '--no-ri --no-rdoc'
  action :install
end
