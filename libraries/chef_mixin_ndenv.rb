# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Library:: mixin_ndenv
#
# Copyright 2011-2014, Numergy
#

require 'chef/mixin/shell_out'

class Chef
  module Mixin
    module Ndenv
      include Chef::Mixin::ShellOut

      def ndenv_command(cmd, options = {})
        unless ndenv_installed?
          raise 'ndenv is not installed, can\'t run ndenv_command.'
        end

        default_options = {
          :user => node['ndenv']['user'],
          :group => node['ndenv']['group'],
          :cwd => node['ndenv']['user_home'],
          :env => { 'NDENV_ROOT' => node['ndenv']['root_path'] },
          :timeout => 3600
        }
        shell_out("#{node['ndenv']['root_path']}/bin/ndenv #{cmd}", Chef::Mixin::DeepMerge.deep_merge!(options, default_options))
      end

      def ndenv_installed?
        shell_out("ls #{node['ndenv']['root_path']}/bin/ndenv").exitstatus == 0
      end

      def node_version_installed?(version)
        shell_out("ls #{node['ndenv']['root_path']}/versions/#{version}").exitstatus == 0
      end

      def ndenv_global_version?(version)
        out = shell_out("cat #{node['ndenv']['root_path']}/version")
        out.stdout.chomp == version
      end
    end
  end
end
