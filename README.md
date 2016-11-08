# LevelKit
SceneKit made simple
## Purpose
To make development of 3D games using Swift's basic shapes quicker,simpler, and more flexible.
## How does it work?
Take a look at this exmaple:
    
    #cube(3)
    position: 0,0,-10
    color: red
    
Instead of having to create an SCNGeometry instance and apply the color and radius to it then wrap it in a SCNNode, our code here is simple. To show this in a SceneKit scene, all we'd have to do is:

    let lvl = LevelKit()
    lvl.loadFile(name: "Map") // Code above should be in a file called Map.3dlevel
    lvl.setView(scn: yourcurrentscene)
    lvl.start()

## Installation
Copy LevelKit.swift into your Xcode project and you're good to go! Everything is contained in that single file!

## What's supported?
Right now, the following geometries are supported:

* cube
* sphere
* tube
* cylinder

More will be added ASAP. Other features in development incude:

* Multiple scenes (just load the new scene file, prerender(), and render())
* (✓) Combining prerender() and render() into one simple function call
* (✓) Movement of nodes via Swift
* More properties

## Disclaimer (as of Saturday, July 23rd, 2016)
LevelKit is written in Swift 3. Therefore LevelKit cannot be used in Apple App Store apps until Apple begins accepting apps written in the new version (most likely when iOS 10 is released) 
