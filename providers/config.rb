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

action :create do
  Chef::Log.info("Creating #{new_resource.name} at #{new_resource.puma_config}") unless puma_config_exist?
  template_variables = {}
  %w(
    group
    owner
    directory
    working_dir
    puma_dir
    rackup
    environment
    daemonize
    pidfile
    statepath
    activate_control_app
    stdout_redirect
    stderr_redirect
    output_append
    quiet
    thread_min
    thread_max
    bind
    control_app_bind
    workers
    worker_timeout
    preload_app
    prune_bundler
    tag
    on_worker_boot
    ).each do |a|
    template_variables[a.to_sym] = new_resource.send(a)
  end

  converge_by("Create puma dir #{new_resource.puma_dir}") do
    directory new_resource.puma_dir do
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode '0755'
      recursive true
      action :create
    end
  end

  converge_by("Create working dir #{new_resource.working_dir}") do
    directory new_resource.working_dir do
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      mode '0755'
      recursive true
      action :create
    end
  end

  converge_by("Render puma config template #{new_resource.puma_config}") do
    template new_resource.puma_config do
      source new_resource.template
      cookbook new_resource.cookbook
      mode '0644'
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      variables template_variables
    end
  end

  converge_by("Create runit script #{new_resource.name}") do
    run_context.include_recipe 'runit'
    runit_service new_resource.name do
      default_logger true
      run_template_name 'puma'
      log_template_name 'puma'
      control_template_names(
        'q' => 'puma'
      )
      cookbook 'puma'
      owner new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group
      control ['q']
      options(
        :working_dir => new_resource.working_dir,
        :puma_dir => new_resource.puma_dir,
        :puma_config_file => new_resource.puma_config,
        :puma_pidfile => new_resource.pidfile,
        :puma_statepath => new_resource.statepath,
        :puma_socket_file => new_resource.bind,
        :puma_control_file => new_resource.control_app_bind,
        :bundle_exec => new_resource.bundle_exec,
        :owner => new_resource.owner,
        :group => new_resource.group
      )
    end
  end
end

action :delete do
  if puma_config_exist?
    if ::File.writable?(new_resource.puma_config)
      Chef::Log.info("Deleting #{new_resource.name} at #{new_resource.puma_config}")
      ::File.delete(new_resource.puma_config)
      new_resource.updated_by_last_action(true)
    else
      fail "Cannot delete #{new_resource.name} at #{new_resource.puma_config}!"
    end
  end
end

private

def puma_config_exist?
  ::File.exist?(new_resource.puma_config)
end
