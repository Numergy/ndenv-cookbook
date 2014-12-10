# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'ndenv::install' do
  describe 'install with default attributes' do

    let(:chef_run) { ChefSpec::ServerRunner.new.converge described_recipe }

    it 'does install node version 0.10.26' do
      expect(chef_run).to install_ndenv_node('0.10.26').with(global: true)
    end
  end

  describe 'install with overriden attributes' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ndenv']['installs'] = ['0.10.20', '0.10.26']
        node.set['ndenv']['global'] = '0.10.26'
      end.converge described_recipe
    end

    it 'does install node version 0.10.20' do
      expect(chef_run).to install_ndenv_node('0.10.20').with(global: false)
    end

    it 'does install node version 0.10.26' do
      expect(chef_run).to install_ndenv_node('0.10.26').with(global: true)
    end
  end

end
