# -*- coding: utf-8 -*-

require 'spec_helper'

describe group 'ndenv' do
  it { should exist }
end

describe user 'vagrant' do
  it { should exist }
  it { should belong_to_group 'ndenv' }
end

describe user 'ndenv' do
  it { should exist }
  it { should belong_to_group 'ndenv' }
  it { should have_home_directory '/home/ndenv' }
  it { should have_login_shell '/bin/bash' }
end

describe file '/home/ndenv' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
end

describe file '/opt/ndenv' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
  it { should be_mode 755 }
end

describe file '/opt/ndenv/plugins' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
  it { should be_mode 755 }
end

describe file '/opt/ndenv/plugins/node-build' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
end

describe file '/etc/profile.d' do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end

describe file '/etc/profile.d/ndenv.sh' do
  it { should be_file }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
  it { should be_mode 644 }
  its(:content) { should match %r{export NDENV_ROOT=/opt/ndenv} }
end

describe file '/opt/ndenv/versions/v0.10.20' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
end

describe file '/opt/ndenv/versions/v0.10.26' do
  it { should be_directory }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
end

describe file '/opt/ndenv/version' do
  its(:content) { should match(/v0.10.20/) }
  it { should be_owned_by 'ndenv' }
  it { should be_grouped_into 'ndenv' }
  it { should be_mode 644 }
end
