require 'spec_helper'

describe file('/srv/apps/phasedrestarts/shared/puma/phasedrestarts.rb') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should contain 'directory "/srv/apps/phasedrestarts/current"' }
end

describe file('/srv/apps/phasedrestarts/shared/puma/phasedrestarts.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/phasedrestarts/shared/puma/phasedrestarts_control.sock') do
  it { should be_socket }
  it { should be_mode 777 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/phasedrestarts/shared/puma/stderr.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/phasedrestarts/shared/puma/stdout.log') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/apps/phasedrestarts/shared/puma/phasedrestarts.pid') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe command('pumactl -S /srv/apps/phasedrestarts/shared/puma/phasedrestarts.state status') do
  it { should return_stdout 'Puma is started' }
end
