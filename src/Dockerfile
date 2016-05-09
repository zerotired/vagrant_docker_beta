FROM debian:jessie
MAINTAINER pansen

RUN apt-get update
RUN apt-get install -y openssh-server daemontools python2.7 net-tools sudo vim
RUN apt-get install -y build-essential python-dev lxc redir libffi-dev libssl-dev
RUN cd /usr/bin && ln -sfn python2.7 python

RUN sed -i -E 's/^lxc.network.type.*$/lxc.network.type = none/' /etc/lxc/default.conf
RUN sed -i -E 's/^Port.*$/Port 6022/' /etc/ssh/sshd_config
RUN adduser --disabled-password --gecos "" --uid 1000 --home /home/vagrant vagrant
# installing `bridge-utils` in the container destroys networking
# RUN echo "lxc.network.link = br0" >> /etc/lxc/default.conf


RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd

RUN mkdir -p /root/.ssh
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 0700 /root/.ssh
RUN chmod 0700 /home/vagrant/.ssh
# taken from https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /root/.ssh/authorized_keys
RUN cat /root/.ssh/authorized_keys > /home/vagrant/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/authorized_keys
RUN chmod 0600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN ln -sfn /srv/Vagrantfile /home/vagrant/

COPY ssh/ssh_host_* /etc/ssh/
RUN chown root:root /etc/ssh/ssh_host_*
RUN chmod 0600 /etc/ssh/ssh_host_*

COPY sudoers.d/vagrant /etc/sudoers.d/vagrant
RUN chown root:root /etc/sudoers.d/vagrant
RUN chmod 0600 /etc/sudoers.d/vagrant

RUN wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb -O /tmp/vagrant_1.8.1_x86_64.deb
RUN dpkg -i /tmp/vagrant_1.8.1_x86_64.deb
RUN rm /tmp/vagrant_1.8.1_x86_64.deb
RUN cd /home/vagrant && sudo -u vagrant -- vagrant plugin install vagrant-lxc

RUN mkdir -p /services/sshd
COPY services/sshd/run /services/sshd/
RUN chown root:root /services/sshd/run
RUN chmod 0744 /services/sshd/run

# ssh from the docker container
EXPOSE 6022

# ssh from our nested box
EXPOSE 22

CMD ["/usr/bin/svscan", "/services"]
