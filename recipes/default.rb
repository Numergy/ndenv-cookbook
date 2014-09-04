# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Recipe:: default
#
# Copyright 2014, Numergy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

directory node['ndenv']['root_path'] do
  owner node['ndenv']['user']
  group node['ndenv']['group']
  mode '0755'
  recursive true
end

git node['ndenv']['root_path'] do
  not_if { File.exist?("#{node['ndenv']['root_path']}/.git") }
  user node['ndenv']['user']
  group node['ndenv']['group']
  repository node['ndenv']['git_repository']
  reference node['ndenv']['git_reference']
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
  repository node['node_build']['git_repository']
  reference node['node_build']['git_reference']
  action :sync
end

directory node['ndenv']['profile_path'] do
  not_if { File.exist?(node['ndenv']['profile_path']) }
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

template "#{node['ndenv']['profile_path']}/ndenv.sh" do
  owner node['ndenv']['user']
  group node['ndenv']['group']
  mode '0644'
end
