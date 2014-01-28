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


def initialize(*args)
  super
  @action = :create
end

actions :create, :delete

attribute :path, :kind_of => String, :name_attribute => true
attribute :template, :kind_of => String, :default => 'puma.rb.erb'
attribute :cookbook, :kind_of => String, :default => 'puma-ng'
attribute :bind, :kind_of => String, :default => 'tcp://127.0.0.1:9292'
attribute :working_dir, :kind_of => String, :default => nil
attribute :rackup, :kind_of => String, :default => 'config.ru'
attribute :environment, :kind_of => String, :default => 'production'
attribute :daemonize, :kind_of => [TrueClass, FalseClass], :default => 'false'
attribute :pidfile, :kind_of => String, :default => 'tmp/puma.pid'
attribute :state_path, :kind_of => String, :default => 'tmp/puma.state'
attribute :stdout_redirect, :kind_of => String, :default => 'log/puma_stdout.log'
attribute :stderr_redirect, :kind_of => String, :default => 'log/puma_stderr.log'
attribute :output_append, :kind_of => [TrueClass, FalseClass], :default => false
attribute :quiet, :kind_of => [TrueClass, FalseClass], :default => false
attribute :thread_min, :kind_of => Fixnum, :default => 0
attribute :thread_max, :kind_of => Fixnum, :default => 16
attribute :activate_control_app, :kind_of => [TrueClass, FalseClass], :default => true
attribute :control_app_bind, :kind_of => String, :default => 'unix:///var/run/pumactl.sock'
attribute :logrotate, :kind_of => [TrueClass, FalseClass], :default => true
attribute :workers, :kind_of => Fixnum, :default => 0
attribute :preload_app, :kind_of => [TrueClass, FalseClass], :default => false
attribute :on_worker_boot, :kind_of => String, :default => nil

attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
