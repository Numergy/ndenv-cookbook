# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Attributes:: default
#
# Copyright 2014, Numergy
#
# All rights reserved - Do Not Redistribute
#

default['ndenv']['user'] = 'ndenv'
default['ndenv']['user_home'] = "/home/#{node['ndenv']['user']}"
default['ndenv']['group'] = 'ndenv'
default['ndenv']['group_users'] = []
default['ndenv']['manage_home'] = true
default['ndenv']['root_path'] = "#{node['ndenv']['user_home']}/.ndenv"
default['ndenv']['profile_path'] = '/etc/profile.d'
