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

def whyrun_supported?
  true
end

use_inline_resources if defined?(use_inline_resources)

def root_directory
  if new_resource.directory
    new_resource.directory
  else
    ::File.join('/srv/apps', new_resource.name)
  end
end

def working_dir
  if new_resource.working_dir
    new_resource.working_dir
  else
    ::File.join(root_directory, '/current')
  end
end

def puma_dir
  if new_resource.puma_dir
    new_resource.puma_dir
  else
    ::File.join(root_directory, '/shared/puma')
  end
end

def puma_config
  if new_resource.puma_config
    new_resource.puma_config
  else
    ::File.join(puma_dir, new_resource.name + '.rb')
  end
end

def statepath
  if new_resource.statepath
    new_resource.statepath
  else
    ::File.join(puma_dir, "#{new_resource.name}.state")
  end
end

def bind
  if new_resource.bind
    new_resource.bind
  else
    ::File.join("unix://#{puma_dir}", "#{new_resource.name}.sock")
  end
end

def control_app_bind
  if new_resource.control_app_bind
    new_resource.control_app_bind
  else
    ::File.join("unix://#{puma_dir}", "#{new_resource.name}_control.sock")
  end
end

def pidfile
  if new_resource.pidfile
    new_resource.pidfile
  else
    ::File.join(puma_dir, "#{new_resource.name}.pid")
  end
end

def stdout_redirect
  if new_resource.stdout_redirect
    new_resource.stdout_redirect
  else
    ::File.join(puma_dir, '/stdout.log')
  end
end

def stderr_redirect
  if new_resource.stderr_redirect
    new_resource.stderr_redirect
  else
    ::File.join(puma_dir, '/stderr.log')
  end
end

action :create do
  Chef::Log.info("Creating #{new_resource.name} at #{puma_config}") unless puma_config_exist?

  converge_by("Create puma dir #{puma_dir}") do
    directory puma_dir do
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode '0755'
      recursive true
      action :create
    end
  end

  converge_by("Create working dir #{working_dir}") do
    directory working_dir do
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode '0755'
      recursive true
      action :create
    end
  end

  if new_resource.preload_app && new_resource.phased_restarts
    warn('preload_app is automatically disabled when phased_restarts are enabled. Set preload_app false to stop seeing this message')
  end

  converge_by("Render puma config template #{puma_config}") do
    template puma_config do
      source new_resource.template
      cookbook new_resource.cookbook
      mode '0644'
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      variables(
        :name => new_resource.name,
        :rackup => new_resource.rackup,
        :environment => new_resource.environment,
        :daemonize => new_resource.daemonize,
        :output_append => new_resource.output_append,
        :quiet => new_resource.quiet,
        :thread_min => new_resource.thread_min,
        :thread_max => new_resource.thread_max,
        :activate_control_app => new_resource.activate_control_app,
        :workers => new_resource.workers,
        :worker_timeout => new_resource.worker_timeout,
        :preload_app => new_resource.preload_app,
        :phased_restarts => new_resource.phased_restarts,
        :prune_bundler => new_resource.prune_bundler,
        :on_worker_boot => new_resource.on_worker_boot,
        :tag => new_resource.tag,
        :bundle_exec => new_resource.bundle_exec,
        :owner => new_resource.owner,
        :group => new_resource.group,
        :directory => root_directory,
        :working_dir => working_dir,
        :puma_dir => puma_dir,
        :statepath => statepath,
        :bind => bind,
        :control_app_bind => control_app_bind,
        :pidfile => pidfile,
        :stdout_redirect => stdout_redirect,
        :stderr_redirect => stderr_redirect
      )
      notifies :restart, "runit_service[puma-#{new_resource.name}]", :delayed
    end
  end

  converge_by("Create runit script #{new_resource.name}") do
    run_context.include_recipe 'runit'
    runit_service "puma-#{new_resource.name}" do
      default_logger true
      run_template_name 'puma'
      log_template_name 'puma'
      finish new_resource.phased_restarts
      finish_script_template_name 'puma'
      control_template_names(
        'q' => 'puma'
      )
      cookbook 'puma'
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      control ['q']
      options(
        :working_dir => working_dir,
        :puma_dir => puma_dir,
        :puma_config_file => puma_config,
        :puma_pidfile => pidfile,
        :puma_statepath => statepath,
        :puma_socket_file => bind,
        :puma_control_file => control_app_bind,
        :bundle_exec => new_resource.bundle_exec,
        :service => new_resource.name,
        :phased_restarts => new_resource.phased_restarts,
        :restart_interval => new_resource.restart_interval,
        :restart_count => new_resource.restart_count,
        :clear_interval => new_resource.clear_interval,
        :owner => new_resource.owner,
        :group => new_resource.group
      )
    end
  end
end

action :delete do
  converge_by("Disabling puma-#{new_resource.name}") do
    run_context.include_recipe 'runit'
    runit_service "puma-#{new_resource.name}" do
      action :disable
    end
  end

  converge_by("Deleting puma_dir #{puma_dir}") do
    directory puma_dir do
      recursive true
      action :delete
    end
  end
end

private

def puma_config_exist?
  ::File.exist?(puma_config)
end
