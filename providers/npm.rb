# -*- coding: utf-8 -*-
#
# Cookbook Name:: ndenv
# Provider:: npm
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

use_inline_resources

include Chef::Mixin::Ndenv

def whyrun_supported?
  true
end

use_inline_resources

action :install do
  name = new_resource.package_name
  version  = new_resource.version
  npm_args = 'install -g '

  if new_resource.source
    npm_args << @new_resource.source
  else
    npm_args << name
    npm_args << "@#{version}" if version
  end

  out = npm_command("-g -j ls #{name}", @new_resource.node_version)
  json_out = ::JSON.parse(out.stdout.strip)

  if json_out.empty?
    converge_by "npm package #{name} is not present, installing it" do
      npm_command!(npm_args, @new_resource.node_version)
      ndenv_command!('rehash')
    end
  elsif version # check for version equality only if version is specified
    present_version = json_out['dependencies'][name]['version']
    if version != present_version
      converge_by "A different version (#{present_version}) of npm package is present. Will install version #{version}" do
        npm_command!(npm_args, @new_resource.node_version)
        ndenv_command!('rehash')
      end
    end
  end
end

action :upgrade do
  name = new_resource.package_name
  converge_by("Upgrade NPM package `#{name}` for node[#{new_resource.node_version}]..") do
    npm_command!("update -g #{name}", new_resource.node_version)
    ndenv_command!('rehash')
  end
end

action :remove do
  name = new_resource.package_name
  out = npm_command("-g ls #{name}", new_resource.node_version)
  if out.exitstatus == 0
    converge_by("Remove NPM package `#{name}` for node[#{new_resource.node_version}]..") do
      npm_command!("remove -g #{name}", new_resource.node_version)
      ndenv_command!('rehash')
    end
  end
end
