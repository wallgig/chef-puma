# Puma [![Build Status](https://secure.travis-ci.org/wallgig/chef-puma.png)](http://travis-ci.org/wallgig/chef-puma)

Chef cookbook for the [puma](http://puma.io) server.

# Requirements

## Chef

Tested on chef 11

## Cookbooks

The following cookbooks are required:

* [runit](http://github.com/hw-cookbooks/runit)

## Platforms

* Debian 7+
* Ubuntu 13.10+

## Resources/Providers

### sidekiq

This generates a puma configuration and creates a [runit](http://smarden.org/runit/) service. This cookbooks expects that you are deploying with
capistrano, but should be flexible enough to tune for whatever you need.

### Actions

* :create create a named puma configuration, and service.
* :delete disable a named puma service, and deletes the puma directory.

### Examples

```ruby
puma_config "app" do
```

```ruby
puma_config "app" do
  directory "/srv/www"
  environment 'staging'
  thread_min 0
  thread_max 16
  workers 2
end
```

```ruby
puma_config 'app' do
  action :delete
end
```

### Attributes
<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td><b>Name attribute:</b> The name of the puma instance.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>rackup</td>
      <td>Rack file</td>
      <td><code>config.ru</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>Rails environment</td>
      <td><code>production</code></td>
    </tr>
    <tr>
      <td>daemonize</td>
      <td>Wether or not to daemonize puma. Setting this to true will
      break runit.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>output_append</td>
      <td>Append log output</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>quiet</td>
      <td>Verbosity level of the puma daemon</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>thread_min</td>
      <td>Minimum start threads</td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td>thread_max</td>
      <td>Maximum number of threads</td>
      <td><code>16</code></td>
    </tr>
    <tr>
      <td>activate_control_app</td>
      <td>Enables the puma control socket</td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>workers</td>
      <td>The number of puma workers</td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td>worker_timeout</td>
      <td>Timeout for puma workers in seconds</td>
      <td><code>30</code></td>
    </tr>
    <tr>
      <td>preload_app</td>
      <td>Should puma preload your application</td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>prune_bundler</td>
      <td>Allow workers to reload bundler context when master process
      is issued a USR1 signal. Needs preload_app to be false.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>on_worker_boot</td>
      <td>Ruby code to run when a worker boots</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>tag</td>
      <td>Additional text to display in the process list</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>bundle_exec</td>
      <td>Should bundle exec be used to start puma</td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>phased_restarts</td>
      <td>Enables phased restarts. This requires you to disable
      preload_app.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>restart_interval</td>
      <td>The minimum delay in second between automatic restarts</td>
      <td><code>30</code></td>
    </tr>
    <tr>
      <td>restart_count</td>
      <td>The maximum number of automatic restarts allowed</td>
      <td><code>3</code></td>
    </tr>
    <tr>
      <td>clear_interval</td>
      <td>Reset the restart count if `clear_interval` seconds have elapsed since
      the last automatic restart</td>
      <td><code>300</code></td>
    </tr>
    <tr>
      <td>owner</td>
      <td>The user puma is run as</td>
      <td><code>www-data</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>The group puma is run as</td>
      <td><code>www-data</code></td>
    </tr>
   </tr>
  </tbody>
</table>

# Attributes

See the `attributes/default.rb` for default values.

* `node['puma']['version']` - Version of puma to install
* `node['puma']['bundler_version']` - Version to bundler to install
* `node['puma']['rubygems_location']` - The location to your `gem` binary.

# Issues

Find a bug? Want a feature? Submit an [issue here](http://github.com/wallgig/chef-puma/issues). Patches welcome!

# Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

# LICENSE & AUTHORS #

* Authors:: Greg Fitzgerald (<greg@gregf.org>)
* Authors:: Yousef Ourabi

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
