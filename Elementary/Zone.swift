//
//  Zone.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 25/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit

class Zone : NSObject, NSCoding {
	
	var id: Int
	var node: SCNNode = SCNNode()
	var empty: Bool
	var texture: String?
	var name: String
	var red: CGFloat = 0.09
	var green: CGFloat = 0.48
	var blue: CGFloat = 0.05
	var textured: Bool = true
	var ground = SCNNode()
    var links = [Int:Int]()
    var blocks = [Block]()
	var counter = 0
	var selectedBlock: Int = -1
	var selectedNode: SCNNode?
	
	
	init(id: Int){
		self.id = id
		self.node.setValue(id, forKey: "id")
		self.name = "Empty zone"
		// debug faces = self.texture = String(id)
		self.texture = "addWorld"
		self.empty = true
        super.init()
        self.buildZone()
	}
	
	func buildZone(){
		let square = SCNBox(width: 1, height: 1, length: 0.00001, chamferRadius: 0.0)
		square.firstMaterial?.specular.contents = UIColor.whiteColor()
		self.node = SCNNode(geometry: square)
		self.setTexture(self.texture, red: self.red, green: self.green, blue: self.blue)
	}
	
	func buildGround() {
		let ground = SCNBox(width: 100, height: 1, length: 100, chamferRadius: 0.0)
		ground.firstMaterial?.specular.contents = UIColor.whiteColor()
		self.ground = SCNNode(geometry: ground)
		self.setTextureGround(self.texture, red: self.red, green: self.green, blue: self.blue)
		self.ground.setValue(-1, forKey: "id")
	}
    
    func getAxisFromGround(min : Bool = true) -> SCNVector3 {
        var v1 = SCNVector3(x:0, y:0, z:0)
        var v2 = SCNVector3(x:0, y:0, z:0)
        World.zones[World.selectedZone!].ground.getBoundingBoxMin(&v1, max:&v2)
        return ((min) ? v1 : v2) // min = true -> we want the tiniest
    }
    
    func buildAllBlocks() -> SCNNode {
        let allBlocksNode = SCNNode()
        
        var blocksMerged = [Int]()
        
        for i in 0..<World.zones[World.selectedZone!].blocks.count {
            if (self.blocks[i].merge.count == 0) { // is the block isn't merged
                
                self.blocks[i].buildBlock()
                allBlocksNode.addChildNode(self.blocks[i].node!)
                
            } else { // if the block is merged
                
                if blocksMerged.indexOf(self.blocks[i].id) == nil { // if we didn't already used it (merged)
                    
                    let parentNode = SCNNode() // parent node
                    parentNode.setValue(true, forKey: "merged")
                    self.blocks[i].buildBlock() // we build the block
                    parentNode.addChildNode(self.blocks[i].node!)
                    
                    for thisBlock: Block in self.blocks {
                        if self.blocks[i].merge.indexOf(thisBlock.id) != nil { // if we are on a block to merge
                            
                            //print("we merged a block \(thisBlock.id)")
                            thisBlock.buildBlock() // we build a block
                            parentNode.addChildNode(thisBlock.node!)
                            blocksMerged.append(thisBlock.id) // we remember that it has been merged (for the next loops)
                            
                        }
                    }
                    
                    blocksMerged.append(self.blocks[i].id)
                    parentNode.position = SCNVector3(x: self.blocks[i].xParent, y: self.blocks[i].yParent, z: self.blocks[i].zParent)
                    allBlocksNode.addChildNode(parentNode)
                }
                
            }
        }
        
        return allBlocksNode
    }
	
    func getIndexFromBlock(idBlock : Int = -1) -> Int? {
        let idBlockFind = (idBlock == -1) ? World.zones[World.selectedZone!].selectedBlock : idBlock
        
        for block: Block in World.zones[World.selectedZone!].blocks {
			if block.id == idBlockFind {
				return World.zones[World.selectedZone!].blocks.indexOf(block)!
			}
		}
		return nil
	}
	
	private func setTextureGround(texture: String?, red: CGFloat, green: CGFloat, blue: CGFloat){
		if texture == nil {
			self.textured = false
			self.texture = nil
			self.red = red
			self.green = green
			self.blue = blue
			self.ground.geometry?.firstMaterial?.diffuse.contents = UIColor(red: red, green: green, blue: blue, alpha: 1)
		} else {
			self.textured = true
			self.texture = texture!
			self.ground.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.texture!)
		}
	}
	
	private func setTexture(texture: String?, red: CGFloat, green: CGFloat, blue: CGFloat){
		if texture == nil {
			self.textured = false
			self.texture = nil
			self.red = red
			self.green = green
			self.blue = blue
			self.node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: red, green: green, blue: blue, alpha: 1)
		} else {
			self.textured = true
			self.texture = texture!
			self.node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.texture!)
		}
	}
	
	func setZone(texture: String?, name: String, red: CGFloat, green: CGFloat, blue: CGFloat){
		self.setTexture(texture, red: red, green: green, blue: blue)
		self.name = name
		self.empty = false
	}
	
	func removeZone(){
		self.name = "Empty zone"
		self.counter = 0
		self.texture = "addWorld"
		self.empty = true
		self.setTexture(self.texture, red: self.red, green: self.green, blue: self.blue)
		self.blocks = []
		self.links.removeAll(keepCapacity: false)
        
        self.removeLinks("zoneId", id: self.id)
        
		Utils.saveZone()
		Utils.saveHome()
	}
    
    func removeLinks(parameter : String, id : Int) {
        //print("removeZone")
        
        switch parameter {
        case "zoneId":
            for zone : Zone in World.zones {
                let array : [Int:Int] = zone.links
                
                for (aKey, _) in array { // we remove it via a zone
                    if (aKey == id) { // we remove all the entries with this id
                        zone.links.removeValueForKey(aKey)
                    }
                }
            }

        case "blockId": // if we remove it via a block
                let array : [Int:Int] = self.links
            
                var idZoneToDel : Int = -1
                
                for (aKey, aValue) in array { // we remove the link associated to the the block in the selected zone
                    if (aValue == id) {
                        idZoneToDel = aKey // we get the linked zone
                        self.links.removeValueForKey(aKey)
                    }
                }
                
                if (idZoneToDel != -1) { // if we found links
                    let arrayZoneToDel : [Int:Int] = World.zones[idZoneToDel].links //we get the links of the linked zone
                    
                    for (aKey, _) in arrayZoneToDel {
                        if (aKey == World.selectedZone) { // we remove the link with the linked zone
                            World.zones[idZoneToDel].links.removeValueForKey(aKey)
                        }
                    }
                }
            
        default:
            print("not working")
        }
        
        Utils.saveHome()
    }

    required init(coder decoder: NSCoder) {
        self.id         = decoder.decodeObjectForKey("id") as! Int
		self.counter    = decoder.decodeObjectForKey("counter") as! Int
        self.empty      = decoder.decodeObjectForKey("empty") as! Bool
        self.texture    = decoder.decodeObjectForKey("texture") as? String
        self.name       = decoder.decodeObjectForKey("name") as! String
        self.red        = decoder.decodeObjectForKey("red") as! CGFloat
        self.green      = decoder.decodeObjectForKey("green") as! CGFloat
        self.blue       = decoder.decodeObjectForKey("blue") as! CGFloat
        self.textured   = decoder.decodeObjectForKey("textured") as! Bool
        self.links      = decoder.decodeObjectForKey("links") as! [Int:Int]
        super.init()
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(id, forKey:"id")
		encoder.encodeObject(counter, forKey:"counter")
        encoder.encodeObject(empty, forKey:"empty")
        encoder.encodeObject(texture, forKey:"texture")
        encoder.encodeObject(name, forKey:"name")
        encoder.encodeObject(red, forKey:"red")
        encoder.encodeObject(green, forKey:"green")
        encoder.encodeObject(blue, forKey:"blue")
        encoder.encodeObject(textured, forKey:"textured")
        encoder.encodeObject(links, forKey:"links")
    }
	
}
