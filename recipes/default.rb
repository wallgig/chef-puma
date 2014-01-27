# Cookbook Name:: puma
# Recipe:: default
#
# Copyright 2013, Yousef Ourabi
#

gem_package 'puma' do
  action :install
  version node['puma']['version']
  gem_binary node['puma']['rubygems_location']
end
