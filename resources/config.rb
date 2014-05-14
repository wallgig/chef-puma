# Author:: Greg Fitzgerald (greg@gregf.org)
# Copyright:: Copyright (c) 2014 Greg Fitzgerald
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :template, :kind_of => String, :default => 'puma.rb.erb'
attribute :cookbook, :kind_of => String, :default => 'puma'
attribute :rackup, :kind_of => String, :default => 'config.ru'
attribute :environment, :kind_of => String, :default => 'production'
attribute :daemonize, :kind_of => [TrueClass, FalseClass], :default => 'false'
attribute :output_append, :kind_of => [TrueClass, FalseClass], :default => false
attribute :quiet, :kind_of => [TrueClass, FalseClass], :default => false
attribute :thread_min, :kind_of => Fixnum, :default => 0
attribute :thread_max, :kind_of => Fixnum, :default => 16
attribute :activate_control_app, :kind_of => [TrueClass, FalseClass], :default => true
attribute :workers, :kind_of => Fixnum, :default => 0
attribute :worker_timeout, :kind_of => Fixnum, :default => 60
attribute :preload_app, :kind_of => [TrueClass, FalseClass], :default => true
attribute :prune_bundler, :kind_of => [TrueClass, FalseClass], :default => false
attribute :on_worker_boot, :kind_of => String, :default => nil
attribute :bundle_exec, :kind_of => [TrueClass, FalseClass], :default => true

attribute :owner, :regex => Chef::Config[:user_valid_regex], :default => 'www-data'
attribute :group, :regex => Chef::Config[:group_valid_regex], :default => 'www-data'

def initialize(*args)
  super
  @action = :create
end

def directory
  ::File.join('/srv/apps', name)
end

def working_dir
  ::File.join(directory, '/current')
end

def puma_dir
  ::File.join(directory, '/shared/puma')
end

def puma_config
  ::File.join(puma_dir, name + '.rb')
end

def statepath
  ::File.join(puma_dir, "#{name}.state")
end

def bind
  ::File.join("unix://#{puma_dir}", "#{name}.sock")
end

def control_app_bind
  ::File.join("unix://#{puma_dir}", "#{name}_control.sock")
end

def pidfile
  ::File.join(puma_dir, "#{name}.pid")
end

def stdout_redirect
  ::File.join(puma_dir, '/stdout.log')
end

def stderr_redirect
  ::File.join(puma_dir, '/stderr.log')
end
