//
//  ShapeViewController.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 25/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit

class ShapeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	
	var previewScene = SCNScene()
	var geometryNode: SCNGeometry = SCNSphere(radius:1)
	var previewNode = SCNNode()
	var shapesTwoD = ["square","rectangle","circle","line", "trapezoid"]
	var shapesThreeD = ["sphere","cube","tube","thinTube","thickTube","torus","thickTorus","pyramid","highPyramid","cylinder","bigCylinder","capsule","cone","cutCone","cbr","cbr0","cbr1","cbr2","cbr3","cbr4","cube1","cube2","cube3","cube4"]
	var selectedShape: Int  = 0
	var isThreeDshape: Bool = true
	
	
	@IBOutlet weak var twoDcollectionView: UICollectionView!
	@IBOutlet weak var threeDcollectionView: UICollectionView!
	@IBOutlet weak var twoDcontainer: UIView!
	@IBOutlet weak var threeDcontainer: UIView!
	@IBOutlet weak var preview: SCNView!
	@IBOutlet weak var tabs: UISegmentedControl!
	
	override func viewDidLoad() {
		preview.allowsCameraControl = true
		super.viewDidLoad()
		threeDcontainer.hidden = false
		twoDcontainer.hidden = true
		self.tabs.selectedSegmentIndex = 1
		
	}
	
	override func viewDidAppear(animated: Bool) {
		self.modifyPreviewZone(self.threeDcollectionView)
	}
	
	@IBAction func dismiss(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func createBlock(sender: AnyObject) {
		
        // we create the block
        World.zones[World.selectedZone!].counter++
        let newBlock = Block(id: World.zones[World.selectedZone!].counter, texture: "addWorld", red: 0, green: 0, blue: 0, x: 0, y: 5, z: 0, shape: self.geometryNode)
        World.zones[World.selectedZone!].blocks.append(newBlock)
        
        // we backup
        Utils.saveHome() // to save the counter
        Utils.saveZone() // to save the zone

        self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func modifyPreviewZone(collectionView: UICollectionView){
		self.previewNode.removeFromParentNode()
		if (collectionView == self.twoDcollectionView){
			isThreeDshape = false
			drawTwoDpreview()
		} else {
			drawThreeDpreview()
			isThreeDshape = true
		}
		self.previewNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "addWorld")
		self.previewNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(1, y: 2, z: 3, duration: 10)))
		self.previewScene.rootNode.addChildNode(previewNode)
		self.preview.scene = previewScene

	}
	
	func drawTwoDpreview() {
		//print("2D shape")
		switch selectedShape {
		case 0:
			self.geometryNode = SCNBox(width: 1, height: 1, length: 0.00001, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 1:
			self.geometryNode = SCNBox(width: 0.5, height: 1, length: 0.00001, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 2:
			self.geometryNode = SCNCylinder(radius: 1, height: 0.000001)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 3:
			self.geometryNode = SCNBox(width: 0.1, height: 2, length: 0.00001, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 4:
			self.geometryNode = SCNBox(width: 1.2, height: 0.8, length: 0.00001, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)

		default:
			break
		}
	}
	
	func drawThreeDpreview(){
		//print("3D shape")
		switch selectedShape {
		case 0:
			self.geometryNode = SCNSphere(radius:1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 1:
			self.geometryNode = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 2:
			self.geometryNode = SCNTube(innerRadius: 0.5, outerRadius: 0.7, height: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 3:
			self.geometryNode = SCNTube(innerRadius: 0.5, outerRadius: 0.51, height: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 4:
			self.geometryNode = SCNTube(innerRadius: 0.3, outerRadius: 0.7, height: 0.5)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 5:
			self.geometryNode = SCNTorus(ringRadius: 0.5, pipeRadius: 0.3)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 6:
			self.geometryNode = SCNTorus(ringRadius: 0.5, pipeRadius: 0.4)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 7:
			self.geometryNode = SCNPyramid(width: 1, height: 1, length: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 8:
			self.geometryNode = SCNPyramid(width: 0.5, height: 1, length: 0.5)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 9:
			self.geometryNode = SCNCylinder(radius: 1, height: 0.8)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 10:
			self.geometryNode = SCNCylinder(radius: 0.5, height: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 11:
			self.geometryNode = SCNCapsule(capRadius: 0.5, height: 2)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 12:
			self.geometryNode = SCNCone(topRadius: 0, bottomRadius: 1, height: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 13:
			self.geometryNode = SCNCone(topRadius: 0.4, bottomRadius: 1, height: 1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 14:
			self.geometryNode = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.2)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 15:
			self.geometryNode = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.3)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 16:
			self.geometryNode = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 17:
			self.geometryNode = SCNBox(width: 1, height: 0.3, length: 1, chamferRadius: 0.2)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 18:
			self.geometryNode = SCNBox(width: 0.3, height: 0.5, length: 1, chamferRadius: 0.2)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 19:
			self.geometryNode = SCNBox(width: 0.3, height: 0.3, length: 1, chamferRadius: 0.2)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 20:
			self.geometryNode = SCNBox(width: 0.3, height: 0.3, length: 1, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 21:
			self.geometryNode = SCNBox(width: 0.5, height: 0.2, length: 0.5, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 22:
			self.geometryNode = SCNBox(width: 0.3, height: 0.5, length: 1, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)
		case 23:
			self.geometryNode = SCNBox(width: 0.3, height: 0.3, length: 1, chamferRadius: 0)
			self.previewNode = SCNNode(geometry: self.geometryNode)

		default:
			break
		}
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (collectionView == self.twoDcollectionView){
			return shapesTwoD.count
		} else {
			return shapesThreeD.count
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if (collectionView == self.twoDcollectionView){
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier("textureCell", forIndexPath: indexPath) as! UICollectionViewCellImage
			let image = UIImage(named: shapesTwoD[indexPath.row])
			cell.imgView.image = image
			// Configure the cell
			return cell
		} else {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier("textureCell", forIndexPath: indexPath) as! UICollectionViewCellImage
			let image = UIImage(named: shapesThreeD[indexPath.row])
			cell.imgView.image = image
			// Configure the cell
			return cell
		}
		
	}
	
	func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		self.selectedShape = (indexPath.row)
		//print(selectedShape)
		self.modifyPreviewZone(collectionView)
		return true
	}
	
	@IBAction func tabsDidChange(sender: AnyObject) {
		
		switch sender.selectedSegmentIndex {
		case 0:
			threeDcontainer.hidden = true
			twoDcontainer.hidden = false
		case 1:
			threeDcontainer.hidden = false
			twoDcontainer.hidden = true
		default :
			break
		}
	}
}

