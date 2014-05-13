require 'spec_helper'

describe file('/srv/apps/racktest/shared/puma/racktest.rb') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should contain 'directory "/srv/apps/racktest/current"' }
end

describe file('/srv/apps/racktest/shared/puma/racktest.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/racktest/shared/puma/racktest_control.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/racktest/shared/puma/stderr.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/racktest/shared/puma/stdout.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/racktest/shared/puma/racktest.pid') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe process('puma') do
  it { should be_running }
end

describe command('pumactl -S /srv/apps/racktest/shared/puma/racktest.state status') do
  it { should return_stdout 'Puma is started' }
end
