# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Recipe:: default
#
# Copyright 2014, Numergy
#

include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'

package 'curl' do
  action :install
end

group node['ndenv']['group'] do
  members node['ndenv']['group_users'] if node['ndenv']['group_users']
end

user node['ndenv']['user'] do
  shell '/bin/bash'
  group node['ndenv']['group']
  supports manage_home: node['ndenv']['manage_home']
  home node['ndenv']['user_home']
end

git node['ndenv']['root_path'] do
  not_if { File.exist?(node['ndenv']['root_path']) }
  user node['ndenv']['user']
  group node['ndenv']['group']
  repository 'git://github.com/riywo/ndenv.git'
  reference 'master'
  action :sync
end

directory "#{node['ndenv']['root_path']}/plugins" do
  not_if { File.exist?("#{node['ndenv']['root_path']}/plugins") }
  owner node['ndenv']['user']
  group node['ndenv']['group']
  mode '0755'
  recursive true
  action :create
end

git "#{node['ndenv']['root_path']}/plugins/node-build" do
  not_if { File.exist?("#{node['ndenv']['root_path']}/plugins/node-build") }
  user node['ndenv']['user']
  group node['ndenv']['group']
  repository 'git://github.com/riywo/node-build.git'
  reference 'master'
  action :sync
end

directory node['ndenv']['profile_path'] do
  not_if { File.exist?(node['ndenv']['profile_path']) }
  owner node['ndenv']['user']
  group node['ndenv']['group']
  mode '0755'
  recursive true
  action :create
end

template "#{node['ndenv']['profile_path']}/ndenv.sh" do
  owner node['ndenv']['user']
  group node['ndenv']['group']
  mode '0644'
end
