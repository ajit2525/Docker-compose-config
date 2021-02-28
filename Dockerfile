FROM centos:7
#installing ssh for making ssh connection between two container that is remote-host and db.
RUN yum -y install openssh openssh-server
#adding user and providing the password
RUN useradd remote_user && \
    echo "remote_user:1234" | chpasswd remote_user && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh
    
#copying the key generated using ssh-keygen.
COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

#changing the owner and the mode to get access.
RUN chown remote_user:remote_user -R /home/remote_user/.ssh/ && \
    chmod 600 /home/remote_user/.ssh/authorized_keys
    
#after importing running the sshkey
RUN ssh-keygen -A

#installing mysql
RUN yum -y install mysql

#installing the pip that will be used to run the pythonscrpt and integrating of aws cli.

RUN curl -O https://bootstrap.pypa.io/2.7/get-pip.py && \
    python get-pip.py && \
    pip install awscli --upgrade

CMD /usr/sbin/sshd -D
