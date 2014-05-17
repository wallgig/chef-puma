#
# Cookbook Name:: puma-test
# Recipe:: default
#

include_recipe 'build-essential'

package 'ruby1.9.1-full'
package 'ruby1.9.1-dev'
package 'libssl-dev'
package 'libsqlite3-dev'

user 'apps-data' do
  home '/srv/app'
end

group 'apps-data' do
  members 'apps-data'
end

directory '/srv/apps/phasedrestarts/releases/' do
  owner 'apps-data'
  group 'apps-data'
  mode '0755'
  recursive true
end

git '/srv/apps/phasedrestarts/releases' do
  repository 'https://github.com/gregf/testapp.git'
  revision 'master'
  user 'apps-data'
  group 'apps-data'
  action :sync
end

link '/srv/apps/phasedrestarts/current' do
  to '/srv/apps/phasedrestarts/releases'
end

gem_package 'bundler'

directory '/srv/apps/phasedrestarts' do
  owner 'apps-data'
  group 'apps-data'
  mode '0755'
  recursive true
  action :create
end

bash 'bundle install' do
  user 'apps-data'
  cwd '/srv/apps/phasedrestarts/current'
  code <<-EOH
  bundle install --jobs 2 --path vendor/bundle
  EOH
end

include_recipe 'puma'

puma_config 'phasedrestarts' do
  preload_app false
  phased_restarts true
  workers 2
end
