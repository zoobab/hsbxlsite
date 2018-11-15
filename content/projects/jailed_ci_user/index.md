---
title: "Jailed CI user"
linktitle: "Jailed CI user"
state: running
---

Our setup for a jailed CI user.

- Create a regular user
    \# adduser --home /home/ci-jail/ci-jail --shell /bin/ash ci-jail
- Install static busybox
    \# apt-get install busybox-static
- Create directories
    \# mkdir /home/ci-jail/dev /home/ci-jail/bin