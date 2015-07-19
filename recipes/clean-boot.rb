#
# Cookbook Name:: mconf-utils
# Recipe:: clean-boot
# Author:: Felipe Cecagno (<felipe@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

script "remove unused kernel packages" do
  interpreter "bash"
  user "root"
  code <<-EOH
    dpkg -l linux-{image,headers}-* | awk '/^ii/{print $2}' | egrep '[0-9]+\.[0-9]+\.[0-9]+' | grep -v $(uname -r | cut -f1,2 -d"-") | xargs apt-get -y purge
  EOH
  # do not execute if there's a pending reboot
  not_if { node.run_state['reboot'] == true }
end
