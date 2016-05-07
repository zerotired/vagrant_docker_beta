FROM debian:jessie
MAINTAINER amb

RUN apt-get update
RUN apt-get install -y openssh-server daemontools python2.7 net-tools sudo vim
RUN cd /usr/bin && ln -s python2.7 python

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd

RUN mkdir -p /root/.ssh
RUN chmod 0700 /root/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB+wDcnncF8MMIUdw8ZT5LUhLkeXcEVGYcQdk+hCI1d+87e1n8ocIZgfPf60EpgoJv8pCIjGgt9ycjejEcPYZeGAg494yYmxvoIOXidgUyLzFcC6UsQzp2jgTqJacm0jcZd3oU07f117N3m4iPGVosvM7guGKGTO6IDWfVmdX4oAY1508522G3Zengn+/EGCRdY2qjs7eIHA4skn4zru5VmSamxEac4piMVO14gghU5QvJkoAAG13ibY0ZupcNAjUu7CxFY6Zd+XgbFJvPSvYCo3DdK8CQaDBtB9KcheGSMy69LNX53QosvkphSgkRVN8402Dis7HaXtQ9FkD/LvLK99csQSRC5gJyxskCZlv4SnEczs3bsWA4j1gouCI1QbxyVMPzz1O2burmj71GpcQHgXf5PgEpqXCXP6uHd6J0VpxyobzF/9oB1zraxScw5EnpOZE+Hk30nLVAJZe/utpBGWNHsRLr7jv36oYl2YIXV9wfUfioyZzzSjsCOCiUecZQngfCTYThppCiq+ccu16J5xY8sLMeup/M+4HdsI32ljocaSWj9ELQMt2O6XRqOcrpcJqX8PJmLmisKQxvwQMagAmJ16f9us+lT+PjF812V2ySl06c7o2wQSMsnWYx7599c04T1DA4MYVdH5pzUEsgaOslzL7GUyuFem9XBQ== amb@third.local" > /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/authorized_keys

COPY ssh/ssh_host_* /etc/ssh/
RUN chown root:root /etc/ssh/ssh_host_*
RUN chmod 0600 /etc/ssh/ssh_host_*

RUN mkdir -p /services/sshd
COPY services/sshd/run /services/sshd/
RUN chown root:root /services/sshd/run
RUN chmod 0744 /services/sshd/run

EXPOSE 22

CMD ["/usr/bin/svscan", "/services"]
