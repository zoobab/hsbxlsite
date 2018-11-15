---
title: "Jailed CI user"
linktitle: "Jailed CI user"
state: running
---

Our setup for a jailed CI user.

- Create a regular user
~~~~
# adduser --home /home/ci-jail/ci-jail --shell /bin/sh ci-jail
~~~~
- Install static busybox
~~~~
# apt-get install busybox-static
~~~~
- Create directories
~~~~
# mkdir -p /home/ci-jail/dev /home/ci-jail/bin /home/ci-jail/www /home/ci-jail/ci-jail/.ssh
~~~~
- Copy busybox to it's destination
~~~~
# cp /bin/busybox /home/ci-jail/bin
~~~~
- Use busybox to install the symlinks in the jail
~~~~
# chroot /home/ci-jail /bin/busybox --install -s /bin
~~~~
- Add your ssh key to the jail
~~~~
# echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC98TAUD9PPuzRj5uyHWlxZiXGLm1JI7T2hPNwmW9pU5V/guoJ90VTNQ7lugEoX8HYxB7JC0/RA5ogJBkhcQHIAMIGT6yM7F2zzVv9LadbiMU0KrB2dZVmPKKxi49uqqj+d8zIWTbm4tLf7xdF42kr7c2AUl1kYzaD1ymlAXSavvHTg7y/h2/mZ36F7WZmVwa7Q6iI5Vuca66lauwGgl1ETS2lwneQn+CWDZFMSFDT9TmphR8mpISi8063oTwvvHa/t0bpeQnKltg1iqM2YGTlIGTgXuEWsiAARfF96zhOUAXseA9WHeCTDUITmycFau4+ILxVH47Z6oC11W52BtwIf frederic@pekko' > /home/ci-jail/ci-jail/.ssh/authorized_keys
~~~~
- Set the permissions to the files and directories
~~~~
# chown -R ci-jail:ci-jail /home/ci-jail/ci-jail
# chown -R ci-jail:ci-jail /home/ci-jail/www
~~~~
- Add the following to your sshd config (file /etc/ssh/sshd):
~~~~
Match user ci-jail
	ChrootDirectory /home/ci-jail
~~~~
- Restart your ssh daemon
~~~~
/etc/init.d/ssh restart
~~~~
