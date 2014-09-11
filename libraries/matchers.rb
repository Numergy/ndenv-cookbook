# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Library:: matchers
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

if defined?(ChefSpec)
  def install_ndenv_node(node_version)
    ChefSpec::Matchers::ResourceMatcher.new(:ndenv_node, :install, node_version)
  end

  def install_ndenv_npm(package_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ndenv_npm, :install, package_name)
  end

  def upgrade_ndenv_npm(package_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ndenv_npm, :upgrade, package_name)
  end

  def remove_ndenv_npm(package_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ndenv_npm, :remove, package_name)
  end
end
