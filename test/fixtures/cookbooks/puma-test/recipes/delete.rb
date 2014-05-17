#
# Cookbook Name:: puma-test
# Recipe:: default
#

include_recipe 'build-essential'

package 'ruby1.9.1-full'
package 'ruby1.9.1-dev'
package 'libssl-dev'
package 'libsqlite3-dev'

user 'www-data' do
  home '/srv/app'
end

group 'www-data' do
  members 'www-data'
end

directory '/srv/www/railstest/releases/' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
end

git '/srv/www/railstest/releases' do
  repository 'https://github.com/gregf/testapp.git'
  revision 'master'
  user 'www-data'
  group 'www-data'
  action :sync
end

link '/srv/www/railstest/current' do
  to '/srv/www/railstest/releases'
end

gem_package 'bundler'

directory '/srv/www/railstest' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
  action :create
end

bash 'bundle install' do
  user 'www-data'
  cwd '/srv/www/railstest/current'
  code <<-EOH
  bundle install --jobs 2 --path vendor/bundle
  EOH
end

include_recipe 'puma'

puma_config 'railstest' do
  directory '/srv/www/railstest'
  workers 2
end

puma_config 'railstest' do
  directory '/srv/www/railstest'
  action :delete
end
