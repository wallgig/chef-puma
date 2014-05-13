#
# Cookbook Name:: puma-test
# Recipe:: default
#

include_recipe 'build-essential'

package 'ruby1.9.1-full'
package 'ruby1.9.1-dev'

package 'libssl-dev'
user 'www-data' do
  home '/srv/app'
end

group 'www-data' do
  members 'www-data'
end

directory '/srv/apps/racktest/current/' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
end

cookbook_file 'config.ru' do
  path '/srv/apps/racktest/current/config.ru'
end

include_recipe 'puma'

puma_config 'racktest' do
  bundle_exec false
end
