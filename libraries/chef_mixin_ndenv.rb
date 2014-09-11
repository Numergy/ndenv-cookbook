# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Library:: mixin_ndenv
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

require 'chef/mixin/shell_out'

class Chef
  module Mixin
    # Chef::Mixin::Ndenv module to manage ndenv commands
    module Ndenv
      include Chef::Mixin::ShellOut

      def ndenv_command(cmd, options = {})
        unless ndenv_installed?
          fail 'ndenv is not installed, can\'t run ndenv_command.'
        end

        default_options = {
          user: node['ndenv']['user'],
          group: node['ndenv']['group'],
          cwd: node['ndenv']['user_home'],
          env: { 'NDENV_ROOT' => node['ndenv']['root_path'] },
          timeout: 3600 }

        shell_out!("#{node['ndenv']['root_path']}/bin/ndenv #{cmd}", Chef::Mixin::DeepMerge.deep_merge!(options, default_options))
      end

      def npm_command(args, node_version)
        node_version = format_node_version(node_version)
        npm_bin_path = npm_binary_path(node_version)

        shell_out!("#{npm_bin_path} #{args}",
                   user: node['ndenv']['user'],
                   group: node['ndenv']['group'],
                   cwd: node['ndenv']['user_home'],
                   env: {
                     'NDENV_VERSION' => node_version,
                     'NDENV_ROOT' => @ndenv_root,
                     'HOME' => node['ndenv']['user_home'] })
      end

      def npm_binary_path(version)
        ndenv_command('which npm', env: { 'NDENV_VERSION' => version }).stdout.chomp
      end

      def format_node_version(version)
        version = "v#{version}" unless version.start_with?('v')
        version
      end

      def ndenv_installed?
        shell_out("ls #{node['ndenv']['root_path']}/bin/ndenv").exitstatus == 0
      end

      def node_version_installed?(version)
        shell_out("ls #{node['ndenv']['root_path']}/versions/#{format_node_version(version)}").exitstatus == 0
      end

      def ndenv_global_version?(version)
        out = shell_out("cat #{node['ndenv']['root_path']}/version")
        out.stdout.chomp == format_node_version(version)
      end
    end
  end
end
