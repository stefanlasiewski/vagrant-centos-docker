# vagrant-centos-docker

Provides a CentOS 7 host running Docker CE, installed per https://docs.docker.com/engine/installation/linux/docker-ce/centos/

Installs CentOS, Docker CE and tests the finished image with `docker run hello-world`.

Supports Docker CE Stable, Edge and Test. See `install-docker.sh` for details.

# Usage

Simply clone this repo, and run `vagrant up`:

```
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'centos/7'...
...
==> default: + sudo docker run hello-world
...
==> default: Status: Downloaded newer image for hello-world:latest
==> default: 
==> default: Hello from Docker!
==> default: This message shows that your installation appears to be working correctly.
...
```

# Testing Docker with Kernel User Namespaces

I am testing Docker with Kernel User Namespaces.

On RHEL/CentOS 7.2 - 7.3, User Namespaces were an experimental "Tech Preview". They are now fully supported in 7.4 according to https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/7.4_release_notes/index .

On RHEL 7.4, User Namespaces are enabled in the Kernel by passing on `user_namespace.enable=1` flag. However, to do useful things with User Namespaces and Docker, the root user within the user namespace will needs the ability to mount and unmount things. Therefore, we also enable `namespace.unpriv_enable=1`.

To enable them here, run the script `enable-user-namespaces.sh` (Modify as necessary) & reboot the VM:


```
$ vagrant ssh
[vagrant@localhost ~]$ sudo bash /vagrant/enable-user-namespaces.sh 
INFO: Add BOTH user_namespace.enable=1 namespace.unpriv_enable=1 option to the kernel (vmlinuz*) command line.
INFO: Kernel command arguments will now be:
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup00/LogVol00 rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet namespace.unpriv_enable=1 user_namespace.enable=1"
INFO: Add a value to the user.max_user_namespaces kernel tuneable so it is set permanently
INFO: Assign users and groups to be mapped by User Namespaces.
INFO: Copy Docker's daemon.json which enables User Namespaces
‘/vagrant/daemon.json’ -> ‘/etc/docker/daemon.json’
INFO: User Namespaces now enabled. Reboot the system to activate them.
INFO: After reboot, check that User Namespaces are enabled per https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index.
[vagrant@localhost ~]$
```

## After reboot, check that User Namespaces are enabled.

We are not running Atomic here, but the Atomic documentation provides some hints
on determing if User Namespaces are enabled at: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#user_namespaces_options

```
[vagrant@localhost ~]$ cat /proc/cmdline |grep --color  user_namespace.enable
BOOT_IMAGE=/vmlinuz-3.10.0-693.5.2.el7.x86_64 root=/dev/mapper/VolGroup00-LogVol00 ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup00/LogVol00 rd.lvm.lv=VolGroup00/LogVol01 rhgb quiet user_namespace.enable=1

[vagrant@localhost ~]$ sudo sysctl -a | grep user.max_user_namespaces
user.max_user_namespaces = 15076

[vagrant@localhost ~]$ sudo docker info |grep --after-context=5 "Security Options"
Security Options:
 seccomp
   Profile: default
    userns
```
