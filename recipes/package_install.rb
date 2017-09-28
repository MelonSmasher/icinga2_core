#
# Cookbook:: icinga2_core
# Recipe:: package_install
#

# If we are on a supported platform
if %w(debian ubuntu redhat centos fedora amazon windows).include?(node['platform'])

  require 'fileutils'

  icinga2_core_lock_dir = '/etc/melonsmasher/icinga2/'

# Install the icinga2 package
  case node['os']
    # Install icinga2 through chocolatey
    when 'windows'
      chocolatey 'icinga2' do
        action :upgrade
      end
    when 'linux'
      # Install icinga2 through yum or apt
      package 'icinga2' do
        action :upgrade
      end
      # Install monitoring plugins
      case node['platform']
        # Debian/Ubuntu
        when 'ubuntu' 'debian'
          package 'nagios-plugins-all' do
            action :upgrade
          end
          if default['icinga2_core']['install_vim_plugin']
            package 'vim-addon-manager' do
              action :install
            end
            package 'vim-icinga2' do
              action :install
            end
            unless File.file?("#{icinga2_core_lock_dir}vim_plugin_enabled")
              execute 'enable vim plugin' do
                command 'vim-addon-manager -w install icinga2'
              end
              file "#{icinga2_core_lock_dir}vim_plugin_enabled" do
                content 'true'
                mode '0755'
                owner 'root'
                group 'root'
              end
            end
          else
            file "#{icinga2_core_lock_dir}vim_plugin_enabled" do
              action :delete
              mode '0755'
              owner 'root'
              group 'root'
            end
          end
        # RHEL based stuff
        when 'redhat', 'centos', 'fedora', 'amazon'
          package 'nagios-plugins-all' do
            action :upgrade
          end
          if node['icinga2_core']['install_vim_plugin']
            package 'vim-icinga2' do
              action :install
            end
          end
      end
      # Make sure the service is enabled and started
      service 'icinga2' do
        action [:enable, :start]
      end
  end
end
