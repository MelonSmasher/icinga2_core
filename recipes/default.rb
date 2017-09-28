#
# Cookbook:: icinga2_core
# Recipe:: default

if %w(debian ubuntu redhat centos fedora amazon windows).include?(node['platform'])

  icinga2_core_lock_dir = '/etc/melonsmasher/icinga2/'

  unless node['platform'] == 'windows'
    directory icinga2_core_lock_dir do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
      action :create
    end
  end

  include_recipe 'icinga2_core::sources'
  include_recipe 'icinga2_core::package_install'
end
