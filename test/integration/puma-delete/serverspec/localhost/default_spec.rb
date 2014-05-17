require 'spec_helper'

describe command('ls /srv/www/railstest/shared/puma/') do
  it { should return_stdout /No such file or directory/ }
end

describe service('puma-railstest') do
  it { should_not be_enabled }
end
