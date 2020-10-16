[![noswpatv3](http://zoobab.wdfiles.com/local--files/start/noupcv3.jpg)](https://ffii.org/donate-now-to-save-europe-from-software-patents-says-ffii/)
# HSBXL site
Build with Hugo static site generator
https://gohugo.io/

## Instructions: new content

### Add an event
- Create an event folder in /content/events.
- Create an event file in your event folder.
  - Example: /content/events/my_awesome_workshop.md
  - See https://gitlab.com/hsbxl/agenda/raw/master/content/events/panpanpan.md for a working example.

### Add a project
- Create a project folder in /content/projects.
- Create a project file in your project folder.
  - Example: /content/projects/my_awesome_project.md
  - See https://gitlab.com/hsbxl/agenda/raw/master/content/projects/the_black_knight.md for a working example.


## Instructions: add page features

### Show an event list (on a project/event page)

~~~
{{< events series="foobar" >}}
~~~
This shows a list of events with 'series' set as 'foobar'  
On and event page, you can add 'series: foobar' on the top to define this as a event of series 'foobar'.

### Add an image gallery
- Create a folder in your event/project directory.
- Put images in the newly created directory.
- Copy/paste following in the event/project file, where you want to have the image gallery listed.
~~~
{{< gallery "image_directory_name" >}}
~~~
! Replace image_directory_name with the name you gave the directory containing the images.

### Embed a youtube video
~~~
{{< youtube oHg5SJYRHA0 >}}
~~~
! Replace oHg5SJYRHA0 with the id of the youtube video you want to embed.  
This id you find from the URL from that youtube video. https://www.youtube.com/watch?v=oHg5SJYRHA0 => oHg5SJYRHA0

### Embed a tweet
~~~
{{< tweet 1058467581231853570 >}}
~~~
! Replace 1058467581231853570 with the id of the youtube video you want to embed.  
This number you find from the URL from that tweet. https://twitter.com/hsbxl/status/1058467581231853570 => 1058467581231853570

## How to run it with Docker

You can build a sef-contained allinone container (nginx+hugo+data) by running the ```./build.sh``` script:

```
$ ./build.sh
Sending build context to Docker daemon  110.5MB
Step 1/9 : FROM jojomi/hugo
latest: Pulling from jojomi/hugo
Digest: sha256:d3c3d278b8193c3c5babda9998af826c5881c4be9dede8e3c2d1771c8cc2e42e
Status: Downloaded newer image for jojomi/hugo:latest
 ---> 2b94015dfb96
Step 2/9 : RUN apk update && apk add nginx
 ---> Using cache
 ---> 68ec5013c53f
Step 3/9 : RUN mkdir -p /var/www/blog
 ---> Using cache
 ---> 20df666ab57b
Step 4/9 : COPY nginx.conf /etc/nginx/nginx.conf
 ---> Using cache
 ---> 857b224ef457
Step 5/9 : COPY . /var/www/blog
 ---> a4a27ad9c855
Step 6/9 : WORKDIR /var/www/blog
 ---> Running in 28ea060ed60d
Removing intermediate container 28ea060ed60d
 ---> 13f70c1e075f
Step 7/9 : RUN hugo
 ---> Running in d490c6994292
Building sites … WARN 2019/01/04 17:41:46 Found no layout for "section", language "en", output format "Calendar": create a template below /layouts with one of these filenam                                                                                                                                                                                                               es: projects/projects.en.calendar.ics, projects/section.en.calendar.ics, projects/list.en.calendar.ics, projects/projects.calendar.ics, projects/section.calendar.ics, proje                                                                                                                                                                                                               cts/list.calendar.ics, projects/projects.en.ics, projects/section.en.ics, projects/list.en.ics, projects/projects.ics, projects/section.ics, projects/list.ics, section/proj                                                                                                                                                                                                               ects.en.calendar.ics, section/section.en.calendar.ics, section/list.en.calendar.ics, section/projects.calendar.ics, section/section.calendar.ics, section/list.calendar.ics,                                                                                                                                                                                                                section/projects.en.ics, section/section.en.ics, section/list.en.ics, section/projects.ics, section/section.ics, section/list.ics, _default/projects.en.calendar.ics, _defa                                                                                                                                                                                                               ult/section.en.calendar.ics, _default/list.en.calendar.ics, _default/projects.calendar.ics, _default/section.calendar.ics, _default/list.calendar.ics, _default/projects.en.                                                                                                                                                                                                               ics, _default/section.en.ics, _default/list.en.ics, _default/projects.ics, _default/section.ics, _default/list.ics
WARN 2019/01/04 17:41:46 Found no layout for "home", language "en", output format "Calendar": create a template below /layouts with one of these filenames: index.en.calenda                                                                                                                                                                                                               r.ics, home.en.calendar.ics, list.en.calendar.ics, index.calendar.ics, home.calendar.ics, list.calendar.ics, index.en.ics, home.en.ics, list.en.ics, index.ics, home.ics, li                                                                                                                                                                                                               st.ics, _default/index.en.calendar.ics, _default/home.en.calendar.ics, _default/list.en.calendar.ics, _default/index.calendar.ics, _default/home.calendar.ics, _default/list                                                                                                                                                                                                               .calendar.ics, _default/index.en.ics, _default/home.en.ics, _default/list.en.ics, _default/index.ics, _default/home.ics, _default/list.ics
WARN 2019/01/04 17:41:46 Found no layout for "section", language "en", output format "Calendar": create a template below /layouts with one of these filenames: projects/proj                                                                                                                                                                                                               ects.en.calendar.ics, projects/section.en.calendar.ics, projects/list.en.calendar.ics, projects/projects.calendar.ics, projects/section.calendar.ics, projects/list.calendar                                                                                                                                                                                                               .ics, projects/projects.en.ics, projects/section.en.ics, projects/list.en.ics, projects/projects.ics, projects/section.ics, projects/list.ics, section/projects.en.calendar.                                                                                                                                                                                                               ics, section/section.en.calendar.ics, section/list.en.calendar.ics, section/projects.calendar.ics, section/section.calendar.ics, section/list.calendar.ics, section/projects                                                                                                                                                                                                               .en.ics, section/section.en.ics, section/list.en.ics, section/projects.ics, section/section.ics, section/list.ics, _default/projects.en.calendar.ics, _default/section.en.ca                                                                                                                                                                                                               lendar.ics, _default/list.en.calendar.ics, _default/projects.calendar.ics, _default/section.calendar.ics, _default/list.calendar.ics, _default/projects.en.ics, _default/sec                                                                                                                                                                                                               tion.en.ics, _default/list.en.ics, _default/projects.ics, _default/section.ics, _default/list.ics
WARN 2019/01/04 17:41:46 Found no layout for "section", language "en", output format "Calendar": create a template below /layouts with one of these filenames: tools/tools.e                                                                                                                                                                                                               n.calendar.ics, tools/section.en.calendar.ics, tools/list.en.calendar.ics, tools/tools.calendar.ics, tools/section.calendar.ics, tools/list.calendar.ics, tools/tools.en.ics                                                                                                                                                                                                               , tools/section.en.ics, tools/list.en.ics, tools/tools.ics, tools/section.ics, tools/list.ics, section/tools.en.calendar.ics, section/section.en.calendar.ics, section/list.                                                                                                                                                                                                               en.calendar.ics, section/tools.calendar.ics, section/section.calendar.ics, section/list.calendar.ics, section/tools.en.ics, section/section.en.ics, section/list.en.ics, sec                                                                                                                                                                                                               tion/tools.ics, section/section.ics, section/list.ics, _default/tools.en.calendar.ics, _default/section.en.calendar.ics, _default/list.en.calendar.ics, _default/tools.calen                                                                                                                                                                                                               dar.ics, _default/section.calendar.ics, _default/list.calendar.ics, _default/tools.en.ics, _default/section.en.ics, _default/list.en.ics, _default/tools.ics, _default/secti                                                                                                                                                                                                               on.ics, _default/list.ics

                   | EN
+------------------+-----+
  Pages            |  86
  Paginator pages  |   0
  Non-page files   | 107
  Static files     |  42
  Processed images |  60
  Aliases          |   8
  Sitemaps         |   1
  Cleaned          |   0

Total in 4856 ms
Removing intermediate container d490c6994292
 ---> 6867ecda9ed5
Step 8/9 : EXPOSE 80
 ---> Running in 28ae313f4e50
Removing intermediate container 28ae313f4e50
 ---> 3077483556f4
Step 9/9 : ENTRYPOINT ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"]
 ---> Running in 10753e52996d
Removing intermediate container 10753e52996d
 ---> e06e8d878b51
Successfully built e06e8d878b51
Successfully tagged hsbxlsite:latest
```

Then run it with the ```./run.sh``` script:

```
./run.sh
0a9365f915425a2efb1991e591144f01f70531a110d2c28808251442e952d880
```

Then try to access the website running on localhost with curl:

```
$ curl localhost
<!doctype html>
<html>
<head>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="author" content="">

<title>Hackerspace Brussels - HSBXL</title>
<meta name="generator" content="Hugo 0.53" />

[...]
```
