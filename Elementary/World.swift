//
//  World.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 16/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit



class World {
	
	static var zones = [Zone]()
	
	static var selectedZone: Int?
    
    static var teleportingZoneId = -1
	
    class func buildWorld(withoutNewZones : Bool = false) -> SCNNode {
		let world = SCNNode()
        if (!withoutNewZones) {
            for i in 0..<6 {
                let newZone = Zone(id: i)
                newZone.node.setValue(i, forKey: "id")
                World.zones.append(newZone)
            }
        }
		
		//we create The Elementary World :D 
		World.zones[0].node.position = SCNVector3Make(0, 0, -0.5)
		World.zones[1].node.position = SCNVector3Make(0, 0, 0.5)
		
		World.zones[2].node.rotation = SCNVector4Make(0.0, 1.0, 0.0, PI / 2)
		World.zones[2].node.position = SCNVector3Make(0.5, 0, 0)
		
		World.zones[3].node.rotation = SCNVector4Make(0.0, 1.0, 0.0, PI / 2)
		World.zones[3].node.position = SCNVector3Make(-0.5, 0, 0)
		
		World.zones[4].node.rotation = SCNVector4Make(1.0, 0.0, 0.0, PI / 2)
		World.zones[4].node.position = SCNVector3Make(0, 0.5, 0)
		
		World.zones[5].node.rotation = SCNVector4Make(1.0, 0.0, 0.0, PI / 2)
		World.zones[5].node.position = SCNVector3Make(0, -0.5, 0)
		
		
		for i in 0..<6 {
			World.zones[i].node.setValue(i, forKey: "id")
			world.addChildNode(zones[i].node)
		}
		
		return world
	
    }
}