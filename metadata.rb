name 'icinga2_core'
maintainer 'Alex Markessinis'
maintainer_email 'markea125@gmail.com'
license 'MIT'
description 'Installs icinga2 core'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version '>= 12' if respond_to?(:chef_version)
version '0.1.5'

issues_url 'https://github.com/MelonSmasher/icinga2_core/issues' if respond_to?(:issues_url)
source_url 'https://github.com/MelonSmasher/icinga2_core' if respond_to?(:source_url)

depends 'chocolatey', '>= 1.2.1'

%w(redhat centos amazon ubuntu debian windows).each do |os|
  supports os
end
