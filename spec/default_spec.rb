# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'ndenv::default' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  # Write full examples using the `expect` syntax
  it 'does includes recipes' do
    expect(subject).to include_recipe('apt')
    expect(subject).to include_recipe('build-essential')
    expect(subject).to include_recipe('git')
  end

  it 'does install packages' do
    expect(subject).to install_package('curl')
  end

  it 'should create group' do
    expect(subject).to create_group('ndenv').with(
      members: []
    )
  end

  it 'should create user' do
    expect(subject).to create_user('ndenv').with(
      shell: '/bin/bash',
      group: 'ndenv',
      supports: { manage_home: true },
      home: '/home/ndenv'
    )
  end

  it 'should prepare directory' do
    expect(subject).to create_directory('/opt/ndenv').with(
      user: 'ndenv',
      group: 'ndenv',
      mode: '0755',
      recursive: true
    )
  end

  it 'should clone ndenv repository' do
    expect(subject).to sync_git('/opt/ndenv').with(
      user: 'ndenv',
      group: 'ndenv',
      repository: 'https://github.com/riywo/ndenv.git',
      reference: 'master'
    )
  end

  it 'should prepare plugins directory' do
    expect(subject).to create_directory('/opt/ndenv/plugins').with(
      user: 'ndenv',
      group: 'ndenv',
      mode: '0755',
      recursive: true
    )
  end

  it 'should clone node-build repository' do
    expect(subject).to sync_git('/opt/ndenv/plugins/node-build').with(
      user: 'ndenv',
      group: 'ndenv',
      repository: 'https://github.com/riywo/node-build.git',
      reference: 'master'
    )
  end

  it 'should create profile directory' do
    expect(subject).to_not create_directory('/etc/profile.d')
  end

  it 'should copy ndenv profile file' do
    expect(subject).to create_template('/etc/profile.d/ndenv.sh').with(
      owner: 'ndenv',
      group: 'ndenv',
      mode: '0644'
    )
  end
end
