FROM centos:7

RUN yum -y install openssh openssh-server

RUN useradd remote_user && \
    echo "remote_user:1234" | chpasswd remote_user && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user/.ssh/ && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

RUN ssh-keygen -A

RUN yum -y install mysql

RUN curl -O https://bootstrap.pypa.io/2.7/get-pip.py && \
    python get-pip.py && \
    pip install awscli --upgrade

CMD /usr/sbin/sshd -D
