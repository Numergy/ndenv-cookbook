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
          if new_resource.node_version.nil?
            fail Chef::Exceptions::Package, "No node version specified for #{new_resource.package_name} package."
          end

          @ndenv_root = node['ndenv']['root_path']
          @candidate_version = 'latest'
        end

        def whyrun_supported?
          true
        end

        def removing_package?
          true
        end

        def load_current_resource
          @current_resource = Chef::Resource::NdenvNpm.new(@new_resource.name)
        end

        def install_package(name, version)
          Chef::Log.info("Install NPM package `#{name}` for node[#{@new_resource.node_version}]..")
          npm_args = 'install -g '

          if @new_resource.source
            npm_args << @new_resource.source
          else
            npm_args << name
            npm_args << "@#{version}" unless version.empty?
          end
          out = npm_command("-v #{name}",  @new_resource.node_version)

          if out.exitstatus == 0
            present_version = out.stdout.strip
            unless version.empty? and version != present_version
              converge_by "npm package #{name} is not present but having different version. installing it version #{version}" do
                npm_command!(npm_args, @new_resource.node_version)
                ndenv_command!('rehash')
              end
            end
          else
            converge_by "npm package #{name} is not present, installing it" do
              npm_command!(npm_args, @new_resource.node_version)
              ndenv_command!('rehash')
            end
          end
        end

        def upgrade_package(name, _version)
          converge_by("Upgrade NPM package `#{name}` for node[#{@new_resource.node_version}]..") do
            npm_command!("update -g #{name}", @new_resource.node_version)
            ndenv_command!('rehash')
          end
        end

        def remove_package(name, _version)
          out = npm_command("-v #{name}",  @new_resource.node_version)
          unless out.exitstatus == 0
            converge_by("Remove NPM package `#{name}` for node[#{@new_resource.node_version}]..") do
              npm_command!("remove -g #{name}", @new_resource.node_version)
              ndenv_command!('rehash')
            end
          end
        end
      end
    end
  end
end
