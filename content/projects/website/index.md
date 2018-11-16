---
title: "This website"
linktitle: "This website"
state: running
maintainer: "betz"
image: "website.png"
---

The website you're currently browsing is build with static site generator '[Hugo](https://gohugo.io/)'.  
The Hugo generator is written in Go and uses the Markdown format for content.  
You find the public repo of this wite on https://gitlab.com/hsbxl/site  

We are using Gitlab-CI to rebuild this complete website with every git push.  
See https://gitlab.com/hsbxl/site/blob/master/.gitlab-ci.yml for the gitlab-ci conf.  
Gitlab-CI fires a container, installs requirements,  
and runs the hugo command to build the static files in a '/public' folder. 

Once the '/public' folder is generated, containing all html, css and js files,  
it copies this folder over to our target server, the server running hsbxl.be.

The Gitlab-CI config:  
~~~~
image: monachus/hugo

before_script:
  - apt-get update
  - apt-get install openssh-client -y
  - eval $(ssh-agent -s)
  - echo "$PRIVKEY" | tr -d '\r' | ssh-add - > /dev/null
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - echo "$KNOWN_HOSTS" > ~/.ssh/known_hosts
  - chmod 644 ~/.ssh/known_hosts

pages:
  script:
  - hugo version
  - hugo
  - echo $(date +%Y.%m.%d)
  - tar cz public | ssh gitlab@hsbxl.be "mkdir -p /www/versions/$(date +%Y.%m.%d); cd /www/versions/$(date +%Y.%m.%d); tar xz; rm /www/live; ln -sf versions/$(date +%Y.%m.%d)/public /www/live"
  artifacts:
    paths:
    - public
  only:
  - master
~~~~
Placing this file named .gitlab-ci.yml in the root of a git repo on Gitlab is enough to define the setup.  
Just add some variables, like the ssh pubkey of your target server and you're done.  

For the SSH user to push the build website from the Gitlab container over to our server,  
we created a '[jailed CI user](../jailed_ci_user)'. Read the project page on how we set this up.