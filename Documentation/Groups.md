# Documentation : Groups

## Introduction
LevelKit provides deep support for grouping shapes created in your 3dlevel file(s). To create a group, call the makeGroup() function of LevelKit (in Swift).

## Example
### GameViewController.swift
    let kit = LevelKit(); // Initilize LevelKit
    kit.loadFile(name: "Map") // Loads Map.3dlevel from your Xcode Project
    lvl.setView(scn: yourscene) // Sets the view to whatever your scene variable is named (in this case 'yourscene')
    lvl.start() // Renders the screen on the view above
    lvl.makeGroup(name: "group") // Creates the group
    
    
# MORE COMING SOON I'LL FINISH THIS DOC LATER
