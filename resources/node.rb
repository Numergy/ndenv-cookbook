# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Resource:: node
#
# Copyright 2014, Numergy
#

actions :install

attribute :name,         kind_of: String
attribute :node_version, kind_of: String
attribute :force,        default: false
attribute :global,       default: false

def initialize(*args)
  super
  @action = :install
  @node_version ||= @name
end
