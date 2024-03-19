FROM php:7.4-apache

# Installing packages including sudo
RUN apt-get update && apt-get -y install net-tools vim nano expect sudo iproute2 iputils-ping openssh-server

# Setting root password
RUN echo 'root:Pr0jectC@ldera' | chpasswd

# Create user bob
RUN useradd bob
RUN echo 'bob:P@ssword' | chpasswd
RUN mkdir -p /home/bob
RUN chown -R bob:bob /home/bob

# Adding bob into sudoers file (VULNERABILITY)
RUN echo 'bob ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/my-user
RUN chmod 0440 /etc/sudoers.d/my-user

# start ssh server'
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 

# expose port 22 for SSH connection
EXPOSE 22

USER bob

# Start SSH service on container startup
CMD sudo service ssh start && tail -f /dev/null
