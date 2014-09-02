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
end
