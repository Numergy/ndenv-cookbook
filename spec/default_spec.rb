# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'ndenv::default' do
  describe 'with default configuration' do
    subject { ChefSpec::ServerRunner.new.converge(described_recipe) }

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
        manage_home: true,
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
      expect(subject).to create_directory('/etc/profile.d').with(
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true)
    end

    it 'should copy ndenv profile file' do
      expect(subject).to create_template('/etc/profile.d/ndenv.sh').with(
        owner: 'ndenv',
        group: 'ndenv',
        mode: '0644'
      )
    end
  end

  describe 'with override parameters' do
    let(:subject) do
      ChefSpec::ServerRunner.new do |node|
        node.override['ndenv']['user'] = 'adm-ndenv'
        node.override['ndenv']['group'] = 'adm-ndenv'
        node.override['ndenv']['group_users'] = ['vagrant']
        node.override['ndenv']['manage_home'] = false
        node.override['ndenv']['root_path'] = '/usr/local/ndenv'
        node.override['ndenv']['git_repository'] = 'https://github.com/fake_account/fake_repo.git'
        node.override['ndenv']['git_reference'] = 'dev'
        node.override['node_build']['git_repository'] = 'https://github.com/fake_account/fake_repo.git'
        node.override['node_build']['git_reference'] = 'dev'
      end.converge(described_recipe)
    end

    it 'should create group' do
      expect(subject).to create_group('adm-ndenv').with(
        members: ['vagrant']
      )
    end

    it 'should create user' do
      expect(subject).to create_user('adm-ndenv').with(
        shell: '/bin/bash',
        group: 'adm-ndenv',
        manage_home: false,
        home: '/home/adm-ndenv'
      )
    end

    it 'should prepare directory' do
      expect(subject).to create_directory('/usr/local/ndenv').with(
        user: 'adm-ndenv',
        group: 'adm-ndenv',
        mode: '0755',
        recursive: true
      )
    end

    it 'should clone ndenv repository' do
      expect(subject).to sync_git('/usr/local/ndenv').with(
        user: 'adm-ndenv',
        group: 'adm-ndenv',
        repository: 'https://github.com/fake_account/fake_repo.git',
        reference: 'dev'
      )
    end

    it 'should prepare plugins directory' do
      expect(subject).to create_directory('/usr/local/ndenv/plugins').with(
        user: 'adm-ndenv',
        group: 'adm-ndenv',
        mode: '0755',
        recursive: true
      )
    end

    it 'should clone node-build repository' do
      expect(subject).to sync_git('/usr/local/ndenv/plugins/node-build').with(
        user: 'adm-ndenv',
        group: 'adm-ndenv',
        repository: 'https://github.com/fake_account/fake_repo.git',
        reference: 'dev'
      )
    end

    it 'should create profile directory' do
      expect(subject).to create_directory('/etc/profile.d').with(
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true)
    end

    it 'should copy ndenv profile file' do
      expect(subject).to create_template('/etc/profile.d/ndenv.sh').with(
        owner: 'adm-ndenv',
        group: 'adm-ndenv',
        mode: '0644'
      )
    end
  end
end
