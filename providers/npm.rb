
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

  out = npm_command("-g -j ls #{name}",  @new_resource.node_version)

  if out.exitstatus == 0
    # check for version equality only if version is specified
    if version
      present_version = ::JSON.parse(out.stdout.strip)['dependencies'][name]['version']
      if version != present_version
        converge_by "A different version (#{present_version}) of npm package is present. Will install version #{version}" do
          npm_command!(npm_args, @new_resource.node_version)
          ndenv_command!('rehash')
        end
      end
    end
  else
    converge_by "npm package #{name} is not present, installing it" do
      npm_command!(npm_args, @new_resource.node_version)
      ndenv_command!('rehash')
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
  out = npm_command("-g ls #{name}",  new_resource.node_version)
  unless out.exitstatus == 0
    converge_by("Remove NPM package `#{name}` for node[#{new_resource.node_version}]..") do
      npm_command!("remove -g #{name}", new_resource.node_version)
      ndenv_command!('rehash')
    end
  end
end
