# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Provider:: node
#
#
# Copyright 2014, Numergy
#

include Chef::Mixin::Ndenv

action :install do
  resource_descriptor = "ndenv_node[#{new_resource.name}] (version #{new_resource.node_version})"

  if !new_resource.force && node_version_installed?(new_resource.node_version)
    Chef::Log.debug "#{resource_descriptor} is already installed so skipping"
  else
    Chef::Log.info "#{resource_descriptor} is building, this may take a while.."

    out = ndenv_command "install #{new_resource.node_version}"

    unless out.exitstatus == 0
      fail Chef::Exceptions::ShellCommandFailed, "\n#{out.format_for_exception}"
    end
  end

  if new_resource.global && !ndenv_global_version?(new_resource.name)
    Chef::Log.info "Setting #{resource_descriptor} as the ndenv global version"
    out = ndenv_command "global #{new_resource.node_version}"

    unless out.exitstatus == 0
      fail Chef::Exceptions::ShellCommandFailed, "\n#{out.format_for_exception}"
    end
  end

  new_resource.updated_by_last_action(true)
end
