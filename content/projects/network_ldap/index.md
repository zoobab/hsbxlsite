---
title: "Network/Ldap"
linktitle: "Network/Ldap"
date: 2018-11-06T22:08:31+01:00
state: archived
maintainer: "askarel"
---

# PEN/OID

We have the following PEN from IANA: 1.3.6.1.4.1.43666.

This is based on previous work by
[User:TQ\_Hirsh](User:TQ_Hirsh "wikilink")

## 1.3.6.1.4.1.43666.1 (EXPERIMENTAL)

## 1.3.6.1.4.1.43666.2 (LDAP)

### 1.3.6.1.4.1.43666.2.1 (LDAP Attribute type)

1.  x-hsbxl-pgpKey - PGP public key used for encrypted communications
2.  x-hsbxl-sponsorID - Sponsoring member
3.  x-hsbxl-membershipReason - Why you're becoming a member
4.  x-hsbxl-sshPubKey - SSH public key

The following entries might be included in the definitive user schema

1.  x-hsbxl-membershipStructuredComm - Structured communication for
    membership payments
2.  x-hsbxl-membershipAccountId - Internal identifier for membership
    account
3.  x-hsbxl-drinksStructuredcomm - Structured communication for drink
    account
4.  x-hsbxl-drinksAccountId - Internal identifier for fridge account
5.  x-hsbxl-RFID-id - Access control token ID

### 1.3.6.1.4.1.43666.2.2 (LDAP Object class)

## 1.3.6.1.4.1.43666.3 (SNMP)

(todo)

## 1.3.6.1.4.1.43666.4 (Member-defined objects)

This arc is reserved for HSBXL member-defined attributes. To use it, get
your uidNumber from our LDAP database, and append it to this OID.
Anything defined below the resulting OID is up to you.

    Example:
    
    Your LDAP uidNumber is 4242. Your personal arc will then be 1.3.6.1.4.1.43666.4.4242.
    
    Your 1.3.6.1.4.1.43666.4.4242 arc can then be subdivided as you like:
     1.3.6.1.4.1.43666.4.4242.1 (arc foo)
     1.3.6.1.4.1.43666.4.4242.2 (arc bar)
     1.3.6.1.4.1.43666.4.4242.3 (arc baz)

# Getting started

    root@xm1:~# apt-get install slapd ldap-utils migrationtools ldapscripts

# Replication

# Adding hosts

When you want to give shell access to a Linux desktop/server you install
to HSBXL userbase, there are a few needed steps:

  - Request a machine account in the ou=machines,dc=hsbxl,dc=be
    organizational unit
  - apt-get install libpam-ldapd
      - Give the IP address of the LDAP server (currently 192.168.255.1)
      - Give the base DN (dc=hsbxl,dc=be)
      - Say yes to all options
  - Edit /etc/pam.d/common-account and add the following line at the
    end:

`session    required   pam_mkhomedir.so skel=/etc/skel/ umask=0022`

  - Edit the /etc/nslcd.conf file:
      - Verify that the server URI is correct:

`uri `<ldap://192.168.255.1>

  -   - Add the machine account details

`binddn uid=`<machinename>`,ou=machines,dc=hsbxl,dc=be`  
`bindpw `<your machine account password>  
`ignorecase yes`

  - Stop the nscd cache daemon (this is the cache daemon, and can get in
    the way during the testing phase)

`/etc/init.d/nscd stop`

  - Restart the nslcd daemon

`/etc/init.d/nslcd restart`

  - Use this command to see if you get more users than what's defined in
    /etc/passwd:

`getent passwd`

  - If you get the user list from the LDAP server, your setup is working
    and you can restart the nscd daemon:

`/etc/init.d/nscd start`

# SUDO

Yes, sudo rights can be managed straight from the LDAP \!

  - install sudo-ldap

`apt-get install sudo-ldap`

  - Edit the file /etc/sudo-ldap.conf:

`URI    `<ldap://192.168.255.1>  
`BASE`