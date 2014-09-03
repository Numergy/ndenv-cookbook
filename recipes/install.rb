# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Recipe:: install
#
# Copyright 2014, Numergy
#

node['ndenv']['installs'].each do |node_version|
  ndenv_node node_version do
    global node_version == node['ndenv']['global']
  end
end
