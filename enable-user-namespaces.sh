#!/usr/bin/env bash

# Borrowed from
# * https://github.com/procszoo/procszoo/wiki/How-to-enable-%22user%22-namespace-in-RHEL7-and-CentOS7%3F
# * https://gist.github.com/dpneumo/279d6bc5dcbe5609cfcb8ec48499701a
# * https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index

# According to these links, both user_namespace.enable=1 namespace.unpriv_enable=1 may be needed:
# * https://discuss.linuxcontainers.org/t/centos-7-kernel-514-693-cannot-start-any-nodes-after-update/641/16
# * https://github.com/moby/moby/issues/35806
# * https://github.com/moby/moby/issues/35336

set -e # Exit if any subcommand fails
#set -x # Print commands for troubleshooting

enable-user-namespaces () {

  echo "INFO: Add BOTH user_namespace.enable=1 namespace.unpriv_enable=1 option to the kernel (vmlinuz*) command line."
  grubby --args="user_namespace.enable=1 namespace.unpriv_enable=1" --update-kernel="$(grubby --default-kernel)"

  echo "INFO: Kernel command arguments will now be:"
  grubby --info "$(grubby --default-kernel)" | egrep "^args"

  echo "INFO: Add a value to the user.max_user_namespaces kernel tuneable so it is set permanently"
  echo "user.max_user_namespaces=15076" >> /etc/sysctl.conf

  echo "INFO: Assign users and groups to be mapped by User Namespaces."
  [[ $(grep dockremap /etc/subuid) ]] || echo dockremap:808080:1000 >> /etc/subuid
  [[ $(grep dockremap /etc/subgid) ]] || echo dockremap:808080:1000 >> /etc/subgid

  echo "INFO: Copy Docker's daemon.json which enables User Namespaces"
  # TODO: What if daemon.json already exists?
  cp -v /vagrant/daemon.json /etc/docker/daemon.json
}

enable-user-namespaces

echo "INFO: User Namespaces now enabled. Reboot the system to activate them."

echo "INFO: After reboot, check that User Namespaces are enabled per https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index." 

