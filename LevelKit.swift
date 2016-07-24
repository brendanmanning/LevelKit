//
//  LevelKit.swift
//  Mapping_Example
//
//  Created by Brendan Manning on 7/5/16.
//  Copyright © 2016 BrendanManning. Apache Liscense 2.0
//

import Foundation
import SceneKit

class LevelKit {
    /* .3dlevel syntax constants */
    private let _DECLARE = "#";
    private var selectednode:SceneNode!
    private var fileURL = String()
    private var nodes = [SceneNode]();
    private var groups = [NodeGroup]();
    private var scene = SCNScene();
    func loadFile(name:String) {
        fileURL = name;
    }
    internal func setView(scn:SCNScene) {
        scene = scn;
    }
    internal func prerender() {
        do {
            let contents = try String(contentsOfFile: Bundle.main().pathForResource(fileURL, ofType: ".3dlevel")!);
            print(contents)
            let lines = contents.components(separatedBy: "#")
            print(lines)
            var index = 0;
            for line in lines {
                if(line == "") { print("blank") } else {
                    // Split the node by lines
                    print(line)
                    let properties = line.components(separatedBy: "\n")
                    print("PROPS ")
                    print(properties)
                    let nodetype = properties[0]
                    let nodegeometry = stringToGeometry(string: nodetype)
                
                    /* THE NODE WE'RE GOING TO BE WORKING WITH */
                    var node = SceneNode();
                    node.setnode(scn: SCNNode(geometry: nodegeometry))
                
                    /* Apply the properties to the node */
                    var propertyIndex = 0;
                    for prop in properties {
                        // if(propertyIndex < 1) { return }
                        // Apply property
                        node = applyProperty(property: prop, node: node)
                        propertyIndex += 1;
                    }
                    index += 1;
                    // Add the node to the array
                    nodes.append(node)
                }
            }
            
        } catch {
            print("error")
        }
    }
    
    internal func render() {
        for node in nodes {
            scene.rootNode.addChildNode(node.getnode())
        }
        print(String(nodes.count) + " nodes added")
    }
    
    // Performs a prerender and render at the same time
    internal func start() {
        self.prerender()
        self.render()
    }
    
    // Selects a SceneNode which all actions will be applied to
    internal func select(name: String) -> Bool {
        for sprite in nodes {
            if sprite.getname() == name {
                selectednode = sprite
                return true
            }
        }
        print("No sprite exists with that name")
        return false
    }
    
    internal func move(x: Float, y: Float, z: Float) -> Bool {
        guard selectednode != nil else {
            print("Attempted to apply an action to a sprite but none was selected. Use the select() function to begin applying actions to a sprite");
            return false;
        }
        
        selectednode.getnode().position.x += x;
        selectednode.getnode().position.y += y;
        selectednode.getnode().position.z += z;
        
        return true;
    }
    
    /* Box
     * Sphere
     * Tube
     */
    func stringToGeometry(string: String) -> SCNGeometry {
        print(string)
        let split = string.components(separatedBy: "(")
        let properties = split[1].replacingOccurrences(of: ")", with: "").components(separatedBy: ",")
        let shape = split[0].lowercased()
        print("SHAPE = " + shape)
        if(shape == "box") {
            if(properties.count != 4) {
                fatalError("Box takes 4 parameters:\nwidth,height,length,chamferRadius")
            }
            return SCNBox(width: CGFloat(Double(properties[0])!), height: CGFloat(Double(properties[1])!), length: CGFloat(Double(properties[2])!
                ), chamferRadius: CGFloat(Double(properties[3])!))
        }
        if(shape == "sphere") {
            if(properties.count != 1) {
                fatalError("Cube takes 1 parameter:\nRadius");
            }
            return SCNSphere(radius: CGFloat(Double(properties[0])!))
        }
        
        if (shape == "tube") {
            if(properties.count != 3) {
                fatalError("Tube takes 3 parameters:\ninnerRadius,outerRadius,height")
                
                
            }
            return SCNTube(innerRadius: CGFloat(Double(properties[0])!), outerRadius: CGFloat(Double(properties[1])!), height: CGFloat(Double(properties[2])!))
        }
        
        fatalError("(FATAL) Error thrown by LevelKit. Shape \"" + shape + "\" not found")
    }
    
    func applyProperty(property: String, node: SceneNode) -> SceneNode {
        // Split on the colon
        let pair = property.replacingOccurrences(of: " ", with: "").components(separatedBy: ":")
        print(pair)
        if(pair[0] == "color") {
            switch pair[1] {
            case "red":
                node.getnode().geometry?.firstMaterial?.diffuse.contents = UIColor.red();
                break;
            case "orange":
                node.getnode().geometry?.firstMaterial?.diffuse.contents = UIColor.orange();
                break;
            case "yellow":
                node.getnode().geometry?.firstMaterial?.diffuse.contents = UIColor.yellow();
                break;
            case "green":
                node.getnode().geometry?.firstMaterial?.diffuse.contents = UIColor.green();
                break;
            case "blue":
                node.getnode().geometry?.firstMaterial?.diffuse.contents = UIColor.blue();
                break;
            default:
                break;
            }
        }
        
        if(pair[0] == "position") {
            let coordinates = pair[1].components(separatedBy: ",")
            print(coordinates)
            if(coordinates.count != 3) {
                fatalError("Property 'position' has 3 parameters:\nx,y,z");
            }
            node.getnode().position = SCNVector3(x: Float(Double(coordinates[0])!), y: Float(Double(coordinates[1])!), z: Float(Double(coordinates[2])!))
        }
        
        if(pair[0] == "name") {
            node.setname(string: pair[1])
        }
        
        if(pair[0] == "group") {
            
        }
        
        return node
    }
    
    internal func makeGroup(name: String) {
        let group = NodeGroup();
        group.setname(string: name)
        groups.append(group)
    }
    
    internal func addToGroup(group: String) {
        for g in groups {
            if g.getname() == group {
                g.add(node: selectednode)
            }
        }
    }
    
    internal func addToGroup(name: String, group: String) -> Bool {
        for n in nodes {
            if n.getname() == name {
                for g in groups {
                    if g.getname() == group {
                        g.add(node: n)
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    internal func moveGroup(group: String, x: Float, y: Float, z: Float) -> Bool {
        if(!doesGroupExist(name: group)) { print("Group " + group + " does not exist"); return false }
        for g in groups {
            if g.getname() == group {
                for node in g.asArray() {
                    node.getnode().position.x += x;
                    node.getnode().position.y += y;
                    node.getnode().position.z += z;
                }
                
                return true
            }
        }
        
        return false;
    }
    
    private func doesGroupExist(name: String) -> Bool {
        for g in groups {
            if g.getname() == name {
                return true
            }
        }
        
        return false;
    }
}

class SceneNode {
    private var node:SCNNode!;
    private var name = "";
    internal func setnode(scn:SCNNode) {
        node = scn;
    }
    internal func setname(string:String) {
        name = string;
    }
    
    internal func getname() -> String {
        return name;
    }
    
    internal func getnode() -> SCNNode {
        return node;
    }
}

class NodeGroup {
    private var nodes = [SceneNode]();
    private var name = "";
    internal func add(array: [SceneNode]) {
        for element in array {
            nodes.append(element)
        }
    }
    internal func add(node: SceneNode) {
        nodes.append(node)
    }
    
    internal func asArray() -> [SceneNode] {
        return nodes;
    }
    
    internal func setname(string: String) {
        name = string;
    }
    
    internal func getname() -> String {
        return name;
    }
}
