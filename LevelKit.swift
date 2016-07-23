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
    
    
    private var fileURL = String()
    private var nodes = [SCNNode]();
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
                    var node = SCNNode(geometry: nodegeometry)
                
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
            scene.rootNode.addChildNode(node)
        }
        print(String(nodes.count) + " nodes added")
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
    
    func applyProperty(property: String, node: SCNNode) -> SCNNode {
        // Split on the colon
        let pair = property.replacingOccurrences(of: " ", with: "").components(separatedBy: ":")
        print(pair)
        if(pair[0] == "color") {
            switch pair[1] {
            case "red":
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.red();
                break;
            case "orange":
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange();
                break;
            case "yellow":
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow();
                break;
            case "green":
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.green();
                break;
            case "blue":
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue();
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
            node.position = SCNVector3(x: Float(Double(coordinates[0])!), y: Float(Double(coordinates[1])!), z: Float(Double(coordinates[2])!))
        }
        
        return node
    }
}
