//
//  Tree.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 08/06/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit


class Tree {
	
	class func buildTree() -> SCNNode {
		let baseHeight:CGFloat = 0.8
		let treeBase = SCNNode(geometry: SCNCylinder(radius: 0.2, height: baseHeight))
		treeBase.setValue(2, forKey: "id")

		treeBase.geometry?.firstMaterial?.diffuse.contents = UIColor.brownColor()

		let numberOfLevels = 4

		var y:Float = Float(baseHeight / 2.0)
		var bottomRadius:CGFloat = 0.8
		var topRadius:CGFloat = 0.5
		var leaveHeight:CGFloat = 0.4
		let lastLevelHeight:CGFloat = 0.6

		let scale:CGFloat = 0.8
		for i in 0..<numberOfLevels {

			if (i == numberOfLevels - 1) {

				topRadius = 0.0
				y += Float((lastLevelHeight - leaveHeight) / 2.0)
				leaveHeight = lastLevelHeight

			}

			let leavesNode = SCNNode(geometry: SCNCone(topRadius: topRadius, bottomRadius: bottomRadius, height: leaveHeight))
			leavesNode.setValue(-1, forKey: "id")

			leavesNode.position.y = y
			y += Float(leaveHeight)

			leavesNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 35/255, green: 82/255, blue: 2/255, alpha: 1)

			treeBase.addChildNode(leavesNode)

			bottomRadius *= scale
			topRadius *= scale

		}
		return treeBase
	}


}
