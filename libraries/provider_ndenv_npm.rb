# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Library:: provider_ndenv_npm
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

require_relative 'chef_mixin_ndenv'

class Chef
  class Provider
    class Package
      # Package provider for npm
      class NdenvNpm < Chef::Provider::Package
        include Chef::Mixin::Ndenv

        def initialize(new_resource, run_context = nil)
          super
          @ndenv_root = node['ndenv']['root_path']
        end

        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
        end

        def npm_binary_path(version)
          ndenv_command('which npm', env: { 'NDENV_VERSION' => version }).stdout.chomp
        end

        def npm_command(args)
          node_version = format_version(@new_resource.node_version)
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

        def install_package(name, version)
          npm_args = 'install '

          if @new_resource.source
            npm_args << @new_resource.source
          else
            npm_args << "-g #{name}"
            npm_args << "@#{version}" unless version.empty?
          end

          npm_command(npm_args)
          ndenv_command('rehash')
        end
      end
    end
  end
end
