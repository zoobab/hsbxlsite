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