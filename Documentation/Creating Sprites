# Documentation : Creating Sprites

## Introduction
In LevelKit, Sprites are configured in a .3dlevel file. Below is an explanation of how the syntax of a .3dlevel file should look to avoid errors. .3dlevel files are loaded using the LevelKit function loadFile(<file name w/out the .3dlevel part>)

## Example Code

    #circle(10)
    name: myfirstcircle
    color: orange
    position: 0,0,0
    #box(4,4,4,0)
    color: blue
    position: 10,0,0

## Explanation
* Line 1: The declaration of a new sprite is the hash/pound/number symbol (#). After the pound is the shape type (in this case "circle") and any parameters that shape takes. Circles accept one argument: the size of their radius
* Line 2: The name property is how this node is accessed via Swift code. Passing a node into LevelKit's select() function means that all actions performed in LevelKit will be performed on that node, unless otherwise sepcified.
* Line 3: The color property is simply the color of the shape (red,orange,yellow,green, and blue are available)
* Line 4: The position property is the node's location in 3D space (x,y,z)
* Line 5: The pound symbol is used again, so LevelKit knows this line begins a new sprite. In this case, a box with a width,height,and length of 4, and a chamferradius (how curved the corners are) of 0
* Line 6: Places the box in 3D space (see explanation of line 4)
* Line 7: The color of the box is blue. Notice that since we didn't declare the name property, the sprite won't be accessible in your Swift code.
