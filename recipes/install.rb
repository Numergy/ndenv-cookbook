# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Recipe:: install
#
# Copyright 2014, Numergy
#

node['ndenv']['installs'].each do |node_version|
  is_global = false
  if node_version == node['ndenv']['global']
    is_global = true
  end

  ndenv_node node_version do
    global is_global
  end
end
