require 'spec_helper'

describe file('/srv/www/railstest/shared/puma/railstest.rb') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should contain 'directory "/srv/www/railstest/current"' }
end

describe file('/srv/www/railstest/shared/puma/railstest.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/www/railstest/shared/puma/railstest_control.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/www/railstest/shared/puma/stderr.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/www/railstest/shared/puma/stdout.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/www/railstest/shared/puma/railstest.pid') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe command('pumactl -S /srv/www/railstest/shared/puma/railstest.state status') do
  it { should return_stdout 'Puma is started' }
end
