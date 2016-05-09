# Vagrant with "native" shared Directories
 
## Purpose
Working with *Vagrant* on non-linux systems is painful since all "shared
folder" options feel slow in some way. On linux, using *vagrant-lxc* as 
*Vagrant* provider, you can use native `bind` mounts, which are fast 
as they share the filesystem directly.
 
*Docker Beta* for Mac provides some improved shared filesystem, which is
faster than `rsync`, *NFS*, etc.

The idea is to create a docker container, having a shared directory to 
the host, which then will be shared again to the *Vagrant* box via `bind` 
mounts (using *vagrant-lxc*).
 
##  Status
- the shared mount works taking advantage of *Docker Beta*s shared 
  filesystem and the `bind` mount of the nested *Vagrant* box, having
  the same filesystem shared. 
- *Vagrant* machine creation fails as the `lxc-attach` command for the 
  network device does not directly apply. 
  this can be fixed manually. 
- the *Vagrant* machines DNS setup is broken after boot. 
  this can be fixed manually. 

##  Howto
### On the Host Machine

```
make build
make run
ssh vagrant@127.0.0.1 -o "Port 2022"
```

### In the Docker Container
(where you just connected via `ssh vagrant@127.0.0.1 -o "Port 2022"`)

```
vagrant up
```

This will fail as the network config for port 22 does not apply correctly.
To workaround this, you need to run this command ...
```
sudo /usr/bin/env lxc-attach --logfile=/var/log/lxc-cbdev.log --logpriority=DEBUG --name cbdev --namespaces 'NETWORK|MOUNT' -- /sbin/ip -4 addr show scope global eth0  \
    && sudo netstat -ntpl
```

... until the port `22` appears in the list:
```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      5718/sshd       
tcp        0      0 0.0.0.0:6022            0.0.0.0:*               LISTEN      7/sshd          
tcp6       0      0 :::22                   :::*                    LISTEN      5718/sshd       
tcp6       0      0 :::6022                 :::*                    LISTEN      7/sshd          
```

You could now call `vagrant up` again and this would finish successfully.

### In the Nested Vagrant Box

Connect to this box from your host via
```
ssh vagrant@127.0.0.1 -o "Port 2023"
```

First we need to hack the Nameserver:
```
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
sudo dhclient -r eth0
```

then all things work smoothly :) 

## TODO 

### Override the Nameserver properly

Usually this should work:
append to `/etc/dhcp/dhclient.conf`:

```
interface "eth0" {
    prepend domain-name-servers 10.0.0.1 8.8.8.8 8.8.4.4;
}
```

then: `sudo dhclient -r eth0`