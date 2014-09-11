# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Provider:: node
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

include Chef::Mixin::Ndenv

action :install do
  node_version = format_node_version(new_resource.node_version)
  resource_descriptor = "ndenv_node[#{new_resource.name}] (version #{node_version})"

  if !new_resource.force && node_version_installed?(node_version)
    Chef::Log.info "#{resource_descriptor} is already installed so skipping"
  else
    Chef::Log.info "#{resource_descriptor} is building, this may take a while.."

    out = ndenv_command "install #{node_version}"

    unless out.exitstatus == 0
      fail Chef::Exceptions::ShellCommandFailed, "\n#{out.format_for_exception}"
    end
  end

  if new_resource.global && !ndenv_global_version?(new_resource.name)
    Chef::Log.info "Setting #{resource_descriptor} as the ndenv global version"
    out = ndenv_command "global #{node_version}"

    unless out.exitstatus == 0
      fail Chef::Exceptions::ShellCommandFailed, "\n#{out.format_for_exception}"
    end
  end

  new_resource.updated_by_last_action(true)
end
