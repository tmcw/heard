# heard

![](http://farm9.staticflickr.com/8316/8041538022_1494e66db1_z.jpg)

This is an Mac OSX App, tested in 10.8, but will likely work in 10.7. It
works with [iTunes](http://www.apple.com/itunes/) and logs listening data.

[![](http://macwright.org/graphics/heard-giant.png)](https://github.com/downloads/tmcw/heard/heard-0.0.1.zip)

A sample song-play recorded by heard:

```javascript
{
  "album" : "On The Water",
  "artist" : "Future Islands",
  "duration" : 291526,
  "id" : "-1183402847677178919",
  "minute" : 1346294601.155178,
  "name" : "On The Water",
  "rating" : null
},
```

Read [more about heard and the visualizations possible with it
on my blog](http://macwright.org/2012/10/01/heard.html).

Internally it uses [CoreData](http://en.wikipedia.org/wiki/Core_Data) for
data storage, and relies on a single third-party library,
[underscore.m](http://underscorem.org/). It uses [CocoaPods](https://github.com/CocoaPods/CocoaPods)
to include that library.

## Running It

This is an unsigned app, not distributed in the Apple Store. To run it on Macs
with Gatekeeper installed, either `(right click or control-click) -> Open` or
turn off Gatekeeper.

## See Also

* This project is possible thanks to learning from the design of
  [Audioscrobber.app](https://github.com/mxcl/Audioscrobbler.app).
