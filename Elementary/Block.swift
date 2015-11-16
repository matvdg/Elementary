//
//  Block.swift
//  Elementary
//
//  Created by Adrian on 06/06/2015.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit

class Block : NSObject, NSCoding {
	
	
	var id: Int
	var texture: String?
	var red: CGFloat = 0.09
	var green: CGFloat = 0.48
	var blue: CGFloat = 0.05
	var x: Float
	var y: Float
	var z: Float
    var rotationX : Float?
    var rotationY : Float?
    var rotationZ : Float?
    var rotationW : Float?
    var scale = Float(1)
	var shape: SCNGeometry
	var node: SCNNode?
    var merge = [Int]()
    var xParent : Float = 0
    var yParent : Float = 0
    var zParent : Float = 0
	
	
	init(id: Int, texture: String?, red: CGFloat, green: CGFloat, blue: CGFloat, x: Float, y: Float, z: Float, shape: SCNGeometry) {
		self.id = id
		self.red = red
		self.blue = blue
		self.green = green
		self.texture = texture
		self.x = x
		self.y = y
		self.z = z
		self.shape = shape
        super.init()
    }
	
    func buildBlock() {
		//print("Scale \(self.scale)")
        
		
		let node = SCNNode(geometry: self.shape)
        node.geometry!.firstMaterial!.emission.contents = UIColor.blackColor()
        node.setValue(self.id, forKey: "id")
		node.position = SCNVector3Make(self.x, self.y, self.z)
        node.scale = SCNVector3Make(self.scale, self.scale, self.scale)
        
        if (self.rotationW != nil) {
            node.rotation = SCNVector4(x: self.rotationX!, y: self.rotationY!, z: self.rotationZ!, w: self.rotationW!)
        }
        
		self.node = node
	}
	
	func setTexture(texture: String?, red: CGFloat, green: CGFloat, blue: CGFloat){
		if texture == nil {
			self.red = red
			self.green = green
			self.blue = blue
			//print("mode color red = \(self.red) green = \(self.green) blue = \(self.blue)")
			let color = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
			self.node?.geometry?.firstMaterial?.diffuse.contents = color
		} else {
			//print("mode texture")
			self.texture = texture!
			self.node?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.texture!)
		}
	}
    
    required init(coder decoder: NSCoder) {
        self.id         = decoder.decodeObjectForKey("id") as! Int
        self.texture    = decoder.decodeObjectForKey("texture") as? String
        self.red        = decoder.decodeObjectForKey("red") as! CGFloat
        self.green      = decoder.decodeObjectForKey("green") as! CGFloat
        self.blue       = decoder.decodeObjectForKey("blue") as! CGFloat
        self.x          = decoder.decodeObjectForKey("x") as! Float
        self.y          = decoder.decodeObjectForKey("y") as! Float
        self.z          = decoder.decodeObjectForKey("z") as! Float
        self.shape      = decoder.decodeObjectForKey("shape") as! SCNGeometry
        self.scale      = decoder.decodeObjectForKey("scale") as! Float
        self.rotationX  = decoder.decodeObjectForKey("rotationX") as? Float
        self.rotationY  = decoder.decodeObjectForKey("rotationY") as? Float
        self.rotationZ  = decoder.decodeObjectForKey("rotationZ") as? Float
        self.rotationW  = decoder.decodeObjectForKey("rotationW") as? Float
        self.merge      = decoder.decodeObjectForKey("merge") as! [Int]
        self.xParent    = decoder.decodeObjectForKey("xParent") as! Float
        self.yParent    = decoder.decodeObjectForKey("yParent") as! Float
        self.zParent    = decoder.decodeObjectForKey("zParent") as! Float
        
        super.init()
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(texture, forKey: "texture")
        encoder.encodeObject(red, forKey: "red")
        encoder.encodeObject(green, forKey: "green")
        encoder.encodeObject(blue, forKey: "blue")
        encoder.encodeObject(x, forKey: "x")
        encoder.encodeObject(y, forKey: "y")
        encoder.encodeObject(z, forKey: "z")
        encoder.encodeObject(shape, forKey: "shape")
        encoder.encodeObject(scale, forKey: "scale")
        encoder.encodeObject(rotationX, forKey: "rotationX")
        encoder.encodeObject(rotationY, forKey: "rotationY")
        encoder.encodeObject(rotationZ, forKey: "rotationZ")
        encoder.encodeObject(rotationW, forKey: "rotationW")
        encoder.encodeObject(merge, forKey: "merge")
        encoder.encodeObject(xParent, forKey: "xParent")
        encoder.encodeObject(yParent, forKey: "yParent")
        encoder.encodeObject(zParent, forKey: "zParent")
    }
    
}