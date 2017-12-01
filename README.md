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

I am testing Docker with Kernel User Namespaces. On CentOS 7.3, User Namespaces are experimental and are disabled by Default. To enable them, run the script `enable-user-namespaces.sh` (Modify as necessary) & reboot the VM.
