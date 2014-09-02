# -*- coding: utf-8 -*-

require 'spec_helper'

describe file '/home/ndenv' do
  it { should be_directory }
end

describe file '/home/ndenv/.ndenv' do
  it { should be_directory }
end

describe file '/home/ndenv/.ndenv/plugins' do
  it { should be_directory }
end

describe file '/home/ndenv/.ndenv/plugins/node-build' do
  it { should be_directory }
end

describe file '/etc/profile.d/ndenv.sh' do
  it { should be_file }
end

describe file '/home/ndenv/.ndenv/versions/v0.10.20' do
  it { should be_directory }
end

describe file '/home/ndenv/.ndenv/versions/v0.10.26' do
  it { should be_directory }
end

describe file '/home/ndenv/.ndenv/version' do
  its(:content) { should match(/v0.10.20/) }
end
