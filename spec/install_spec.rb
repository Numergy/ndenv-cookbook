# -*- coding: utf-8 -*-

require_relative 'spec_helper'

describe 'ndenv::install with default attributes' do

  let(:chef_run) { ChefSpec::Runner.new.converge 'ndenv::install' }

  it 'does install node version 0.10.26' do
    expect(chef_run).to install_ndenv_node('0.10.26').with(global: true)
  end
end

describe 'ndenv::install with overriden attributes' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['ndenv']['installs'] = ['0.10.20', '0.10.26']
      node.set['ndenv']['global'] = '0.10.26'
    end.converge 'ndenv::install'
  end

  it 'does install node version 0.10.20' do
    expect(chef_run).to install_ndenv_node('0.10.20').with(global: false)
  end

  it 'does install node version 0.10.26' do
    expect(chef_run).to install_ndenv_node('0.10.26').with(global: true)
  end
end
