#
# Cookbook:: icinga2_core
# Recipe:: sources
#

# If we are on a supported platform
if %w(debian ubuntu redhat centos fedora amazon windows).include?(node['platform'])

  icinga2_core_lock_dir = '/etc/melonsmasher/icinga2/'

  case node['platform']
    when 'debian', 'ubuntu' # for Debian based systems
      # Make sure we have wget
      package 'install wget' do
        package_name 'wget'
        action :install
      end
      unless File.file?("#{icinga2_core_lock_dir}icinga2_apt_key_added")
        # Install the apt key we need
        execute 'add apt key' do
          command 'wget -O - https://packages.icinga.com/icinga.key | apt-key add -'
        end
        file "#{icinga2_core_lock_dir}icinga2_apt_key_added" do
          content 'true'
          mode '0755'
          owner 'root'
          group 'root'
        end
      end
      # Add the apt sources
      template '/etc/apt/sources.list.d/icinga.list' do
        source 'icinga_debian.list.erb'
      end
    when 'redhat', 'centos', 'fedora', 'amazon' # for RHEL based systems
      # don't keep running this
      #unless File.file?("#{icinga2_core_lock_dir}icinga2_yum_repo_added")
      # What version of RHEL?
      case node['platform_version'].to_i
        when 6
          rpm_package 'icinga-rpm-release' do
            allow_downgrade true
            source 'https://packages.icinga.com/epel/icinga-rpm-release-6-latest.noarch.rpm'
            action :install
          end
        when 7
          rpm_package 'icinga-rpm-release' do
            allow_downgrade true
            source 'https://packages.icinga.com/epel/icinga-rpm-release-7-latest.noarch.rpm'
            action :install
          end
      end
      file "#{icinga2_core_lock_dir}icinga2_yum_repo_added" do
        content 'true'
        mode '0755'
        owner 'root'
        group 'root'
      end
    #end
    when 'windows'
      include_recipe 'chocolatey'
  end
end
