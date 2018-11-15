---
title: "The black knight"
linktitle: "The black knight"
state: running
maintainer: "askarel"
---

This project describes the plans to build a RFID based scalable doorlock.


# Door hardware
* One (soon two) 5000N magnetic lock, with feedback relay
* One leaf switch
* One electric strike (powered on=open)
* 3 button mouse doorbell button
* 'Door open' push button

# TODO 
* Mail box to collect physical mail, with a switch to detect incoming mail
* Finish Wiring the system
* Install tripwire
* Install panic button

# Current version 
## Hardware
* Raspberry Pi based
* 74LS673 shift register to drive output relays, buzzer, status LED and input multiplexer
* 74150 input multiplexer to monitor inputs. The address is coming from 4 bits of the 74LS673
** This setup implies 16 writes for 1 full reading
* RFID reader: ACR122U, mounted on the inside of the door.
* Extra power supply module for the RFID reader (ACR122U requires 200 mA to work), built as a splice in the USB cable
* Main power: 12VDC 60W power supply, located in basement fusebox

## Hardware control software 
* Install the free pascal compiler on the raspberry pi (apt-get install fpc)
* Download [https://github.com/askarel/hsb-scripts/blob/master/io/pigpio.pas pigpio.pas] and [https://github.com/askarel/hsb-scripts/blob/master/io/blackknightio.pas blackknightio.pas]
* Compile the main program (fpc blackknightio.pas)
This software bring the shift register and input multiplexer contraption to life. It consist of 3 modules coupled by a chunk of shared memory
* Main daemon: running the hardware, monitoring the shared memory buffer for commands, and update status fields
* Full screen Monitor mode: dump status of inputs and outputs, can send some commands to the main daemon
* Command line interface: Some command line options send the order to the daemon and immediately return to caller.
The daemon forks and call an external script with a command line parameter whenever there is an event at the door. This architecture enable the system to be extended to do things that were not foreseen at the time of conception. (Speech was not in the original design, but adding it was a trivial one-liner of shell script)

## Monitored items
* door bell
* mail box
* door state (Open/Closed)
* Magnetic locks state
* 'Door open' button
* Hallway light
* Panic switch
* Tripwire loop

## Insert links to datasheets
* 74ls673 (16 bits shift register with latch)
* 74150 (16 inputs selector, 4  bits control)

## Authentication (this part is subject to change)
* TagEventord is not working with the ACR122U reader
* Shell script polling the RFID reader using scriptor
* When a tag is detected, call the door controller to sound the buzzer (audio feedback)
* hash the result and look it up from a MySQL database
* If authentication successful, call the controller program with the open parameter 

## Web interface
* Written in Javascript and Node.JS
* Controller software sending callbacks using wget in the event script

## Bugs
* This setup has a few hardware bugs
** No provision for battery power
** Plastic box
* The web interface must be moved off the raspi to a more potent host
* The RFID database is currently NOT scalable and a maintenance headache: the Raspberry Pi is doing all the work!
** The database should be re-arranged around a master database and the client(s) would pull the latest copy with a cron job

# Version 2 proposal
* ATmega328 (Arduino)-based controller
** Easier and cheaper to replicate
* Analog monitoring (magnet consumption, battery health and usage)
* Add battery mode (lead-acid battery)
* Turn the raspberry Pi into a SIP intercom
* Use the extra memory chip to store the authentication hashes (better security)
** RFID reader ---USB---> Raspberry Pi <---RS232 serial interface---> ATMega
** Still have authentication flexibility
* Metal box, with tamper switch

## Authentication technology
* Stay with RFID
** Add possibility to use smartphone NFC
* Add iButton option (100% microcontroller contained)
* Hack proposal: The JACK (a tiny microcontroller in a 6,3 mm JACK connector)

## Part selection (may change)
* pcf8574/pcf8574a (gpio)
* pcf8591 (adc)
* 24LC256 (32KB of I²C EEPROM) [http://www.hobbytronics.co.uk/arduino-external-eeprom http://www.hobbytronics.co.uk/arduino-external-eeprom]
* DS1337/DS1307 real time clock

# THIS PART OF THE PAGE NEED TO BE REWORKED OR REMOVED, DEPENDING ON THE EVOLUTION
## Built
The schematic of the board is fairly simple and can be deduced using the source code and the chips datasheets. A schematic drawing should be included.
* detect the status of the doorhandle
* detect the status of the lock (aka traditional Key usage)
* monitor door and locking mechanism

# software

## library & daemon compilation
some work was done during a frackfriday (notes here https://hackerspace.be/Frackfriday_RFID%27s )

tagEventor :
*cf. http://0110.be/artikels/lees/Touchatag_RFID_reader_and_Ubuntu_Linux
*svn export http://tageventor.googlecode.com/svn/trunk/ tageventor

patch like :
~~~~
/* The pscslit libraries*/
  have some problems in the debian srcs, 
  self references were missing directory reference (PCSC/)

compilation errors if you don't :

  In file included from src/tagReader.c:26:0:
  /usr/include/PCSC/winscard.h:20:22: fatal error: pcsclite.h: No such file or directory

In file included from /usr/include/PCSC/winscard.h:20:0,
  from src/tagReader.c:26:
  /usr/include/PCSC/pcsclite.h:24:22: fatal error: wintypes.h: No such file or directory

change <pcslite.h> to <PCSC/pcsclite.h> in winscard.h
change <wintypes.h> to <PCSC/wintypes.h> in pcslite.h.h

/*source*/
  replaced in all sources <tagReader.h> w/ "tagReader.h" 

tageventor.c: :
  removes refs to gui thingies in the makefile
  patch bug causing segfault : l 290  if ( pTag->contents.pData){free} 
  -> comment it all the way it's a pointer to a static thingy, no need to free in this version

acr122UDriver.c : add tikitag tag
  static const int SUPPORTED_READER_NAME_ARRAY_COUNT = 2;
  static const char * const SUPPORTED_READER_NAME_ARRAY[] = { "ACS ACR 38U-CCID","ACS AET65" };

svn export http://tageventor.googlecode.com/svn/trunk/ tageventor
~~~~

to get sources, patched, no gui version here
[[File:Tageventor-Newbuild.tar.gz]]

## installation

install tageventor:

~~~~
  sudo cp tagEventord /usr/bin
  sudo mkdir -p /etc/tagEventord/scripts/
~~~~

/*note to self : should make a "make install" target*/
init.d script :
~~~~
  #! /bin/sh
  # /etc/init.d/tagEventord
  #
  ### BEGIN INIT INFO
  # Provides:          tagEventord
  # Required-Start:    $syslog $pcscd
  # Required-Stop:     $syslog $pcscd
  # Should-Start:      fam
  # Should-Stop:       fam
  # Default-Start:     2 3 4 5
  # Default-Stop:      0 1 6
  # Short-Description: Start the tageventor daemon.
  # Description:       nfc eventing daemon
  ### END INIT INFO
  # Carry out specific functions when asked to by the system
  TEST=$(id | grep 'uid=0' )
  echo $TEST
  if [ $TEST="" ]
  then
        echo "you don't have the privileges"
        exit 0
  fi
  case "$1" in
  start)
    echo "Starting tagEventord "
    cd /etc/tagEventord
    /usr/bin/tagEventord &
    echo $!|tee /var/run/tagEventor.pid
    ;;
  startverbose)
    echo "Starting tagEventord "
    cd /etc/tagEventord
    tagEventord -v99 &
    echo $!|tee /var/run/tagEventor.pid
    ;;
  stop)
    echo "Stopping script tagEventord"
    kill -9 `cat /var/run/tagEventor.pid`
    rm /var/run/tagEventor.pid
    ;;
  restart)
        echo "Stopping script tagEventord"
        kill -9 `cat /var/run/tagEventor.pid`
        rm /var/run/tagEventor.pid
        echo "Starting tagEventord "
        cd /etc/tagEventord
        /usr/bin/tagEventord &
        echo $!|tee /var/run/tagEventor.pid 
        ;;
  status)
        if [ -f /var/run/tagEventor.pid ];then
        echo tagEventord is running
        else
        echo tagEventord is not running
        fi 
        ;;
  *)
    echo "Usage: /etc/init.d/tagEventord {start|stop|status|starverbose}"
    exit 1
    ;;
  esac
  exit 0

  sudo cp ./tagEventor.initscript /etc/init.d/tagEventor
  sudo chmod 755 /etc/init.d/tagEventor
  update-rc.d tagEventor defaults

generic script : /etc/tagEventord/scripts/generic

  #! /bin/bash
  # $1 = UID (unique ID of the tag, as later we may use wildcard naming)
  # $2 = Event Type (IN for new tag placed on reader, OUT for tag removed from reader)
  # show a message in a dialog on the screen
   RES=`mysql -u rfid_shell_user -p'ChangeMe' --skip-column-names -B -e "call rfid_db_hsbxl.checktag('"$1"');" rfid_db_hsbxl`
   echo `date +"%s"`" UID $1, T $2 $RES" >> /tmp/tagEventorLog
   echo `date +"%s"`" UID $1, T $2 $RES" > /tmp/tagEventorLastEvent
   if [ -n "$RES" ]; then
   logger "UID $1, T $2 $RES" 
   echo "4" > /sys/class/gpio/export
   echo "out" > /sys/class/gpio/gpio4/direction
   echo "1" > /sys/class/gpio/gpio4/value
   sleep 5
   echo "0" > /sys/class/gpio/gpio4/value 
   else
   logger "WARNING UNKNOWN UID $1, T $2 PROVISIONNING ?"
   fi


## database

i scaled down the db a bit to the bare essentials :

  drop database IF EXISTS rfid_db_hsbxl;
  create database rfid_db_hsbxl;
  use rfid_db_hsbxl;
  create table user_roles (
   rolename varchar(10),
   can_login boolean not null,
   can_provision boolean not null,
   can_deprovision boolean not null,
   primary key (rolename)
  ) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci;
  create table users (
   login varchar(100),
   hash binary(60) not null,
   user_role varchar(10) not null,
   password_reset boolean not null,
   primary key(login),
   INDEX (user_role),
   CONSTRAINT fk_user_role FOREIGN KEY (user_role) REFERENCES user_roles(rolename)
  ) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci;
   create table tags_status (
    status_name varchar(20),
    status_is_valid boolean not null,
    primary key (status_name)
   ) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci;
   create table tags (
    UID varchar(100),
    status varchar(20),
    primary key (UID),
    INDEX (status),
    CONSTRAINT fk_status FOREIGN KEY (status) references tags_status(status_name)
   ) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci;
   create table users_vs_tags (
    user_login varchar(100),
    tag_UID varchar(100),
    primary key (user_login,tag_UID),
    INDEX (tag_UID),
    INDEX (user_login),
    constraint U_tag_UID unique (tag_UID),
    CONSTRAINT fk_user_login FOREIGN KEY (user_login) references users(login),
    CONSTRAINT fk_tag_UID FOREIGN KEY (tag_UID) references tags(UID) 
   ) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci;
   INSERT into tags_status values('DISABLED',FALSE);
   INSERT into tags_status values('STOLEN',FALSE);
   INSERT into tags_status values('LOST',FALSE);
   INSERT into tags_status values('ACTIVE',TRUE);
   INSERT INTO user_roles values('DESACTIVATED_USER',FALSE,FALSE,FALSE);
   INSERT INTO user_roles values('NORMAL_USER',TRUE,FALSE,FALSE);
   INSERT INTO user_roles values('NORMAL_ADMIN',TRUE,TRUE,TRUE);
   INSERT INTO tags values('043444b9232580','ACTIVE');
   INSERT INTO tags values('1ddc8dad','ACTIVE');
   INSERT INTO tags values('045fdfea412b80','ACTIVE');
   INSERT INTO tags values('04335eb9232580','ACTIVE');
   INSERT INTO users values('jegeva','$2y$11$wQbqox2sUzziApwzke3C6uPDHe5zV5J6pt9aeRpclNmjOgGMxrf3i','NORMAL_ADMIN',FALSE);
   INSERT INTO users values('w00ter','$2y$10$Q1yb0JguV0hUHq818W9YUO1q712FL0tgeRvase3WVImcGCzUPD1qu','NORMAL_ADMIN',FALSE);
   INSERT INTO users values('Askarel','$2y$10$Q1yb0JguV0hUHq838WEYUOoq7121L0tgeRvase3WVImcGCzUPD1qu','NORMAL_ADMIN',FALSE);
   INSERT INTO users values('TomB','$2y$10$Q1yb0JguV0hUHq8N8WE8UOoq712FL0tgeR1ase32VImcGCzUPD1qu','NORMAL_USER',FALSE);
   insert into users_vs_tags values('jegeva','1ddc8dad');
   insert into users_vs_tags values('w00ter','043444b9232580');
   insert into users_vs_tags values('Askarel','045fdfea412b80');
   insert into users_vs_tags values('TomB','04335eb9232580');
   drop procedure IF EXISTS rfid_db_hsbxl.checktag;
   DELIMITER $$
   create procedure rfid_db_hsbxl.checktag (IN theTag varchar(100))
   BEGIN
    SELECT login FROM tags,tags_status,users,users_vs_tags WHERE status_name=status AND status='ACTIVE' AND login=user_login AND UID=tag_UID AND UID=theTag;
   END;
   $$
   DELIMITER ;
   DELIMITER $$
   CREATE TRIGGER user_desactivated before update on users FOR EACH ROW 
   BEGIN
    IF NEW.user_role='DESACTIVAT' THEN
    UPDATE tags set status = 'DISABLED' where UID in (select tag_UID as UID from users_vs_tags where user_login= NEW.login);
    END IF;
    IF not NEW.user_role='DESACTIVAT' THEN
     UPDATE tags set status = 'ACTIVE' where UID in (select tag_UID as UID from users_vs_tags where user_login= NEW.login AND status = 'DISABLED');
    END IF;
   END;
   $$
   DELIMITER ;
   grant select on rfid_db_hsbxl.* to 'rfid_web_user'@'localhost' identified by 'ChangeMe';
   grant insert on rfid_db_hsbxl.tags to 'rfid_web_user'@'localhost';
   grant insert on rfid_db_hsbxl.users to 'rfid_web_user'@'localhost';
   grant insert on rfid_db_hsbxl.users_vs_tags to 'rfid_web_user'@'localhost';
   grant update on rfid_db_hsbxl.tags to 'rfid_web_user'@'localhost';
   grant update on rfid_db_hsbxl.users to 'rfid_web_user'@'localhost';
   grant update on rfid_db_hsbxl.users_vs_tags to 'rfid_web_user'@'localhost';
   grant execute on procedure rfid_db_hsbxl.checktag to 'rfid_shell_user'@'localhost' identified by 'ChangeMe';
~~~~