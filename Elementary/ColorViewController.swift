//
//  ColorViewController.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 25/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit

class ColorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var red: CGFloat = 0.09
	var green: CGFloat = 0.48
	var blue: CGFloat = 0.05
	var textures: [String] = []
	var selectedTexture: Int? = nil
	var floorNode = SCNNode()
	var previewScene = SCNScene()
	var didChange: Bool = false
	
	@IBOutlet weak var colorsContainer: UIView!
	@IBOutlet weak var texturesContainer: UIView!
	@IBOutlet weak var preview: SCNView!
	@IBOutlet weak var tabs: UISegmentedControl!
	@IBOutlet weak var redLevel: UISlider!
	@IBOutlet weak var greenLevel: UISlider!
	@IBOutlet weak var blueLevel: UISlider!
	
	override func viewDidLoad() {
		preview.allowsCameraControl = true
		super.viewDidLoad()
		self.textures = createTexture()
		texturesContainer.hidden = true
		colorsContainer.hidden = false
		self.redLevel.value = Float(self.red)
		self.greenLevel.value = Float(self.green)
		self.blueLevel.value = Float(self.blue)
		
	}
	
	override func viewDidAppear(animated: Bool) {
		self.initPreviewZone()
		self.redLevel.value = Float(self.red)
		self.greenLevel.value = Float(self.green)
		self.blueLevel.value = Float(self.blue)
	}
	
	func createTexture() -> [String] {
		var tab: [String] = []
		for i in 0...33 {
			let name = "t\(i).png"
			tab.append(name)
		}
		return tab
	}
	
	@IBAction func redSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.red = CGFloat(redLevel.value)
		//print(self.red)
		self.modifyPreviewZone()
	}
	
	@IBAction func greenSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.green = CGFloat(greenLevel.value)
		//print(self.green)
		self.modifyPreviewZone()
	}
	
	@IBAction func blueSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.blue = CGFloat(blueLevel.value)
		//print(self.blue)
		self.modifyPreviewZone()
	}
	
	@IBAction func dismiss(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func colorBlock(sender: AnyObject) {
		// we create the zone either with a color or a texture
		var texture: String? = nil
		if self.selectedTexture != nil {
			texture = self.textures[self.selectedTexture!]
		}
		if didChange {
			let index = World.zones[World.selectedZone!].getIndexFromBlock()
			World.zones[World.selectedZone!].blocks[index!].setTexture(texture, red: self.red, green: self.green, blue: self.blue)
			
			Utils.saveZone()
			colorChanged = true
		}
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func initPreviewZone(){
		// reload current color OR texture
		let index = World.zones[World.selectedZone!].getIndexFromBlock()
		
		floorNode.removeFromParentNode()
		floorNode = SCNNode(geometry: World.zones[World.selectedZone!].blocks[index!].shape)
		
		floorNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(1, y: 2, z: 3, duration: 10)))
		previewScene.rootNode.addChildNode(floorNode)
		preview.scene = previewScene
		self.preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.emission.contents = UIColor.blackColor()
		if World.zones[World.selectedZone!].blocks[index!].texture != nil {
			self.tabs.selectedSegmentIndex = 1
			self.texturesContainer.hidden = false
			self.colorsContainer.hidden = true
			self.preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.diffuse.contents = UIImage(named: World.zones[World.selectedZone!].blocks[index!].texture!)
		} else {
			self.tabs.selectedSegmentIndex = 0
			self.redLevel.value = Float(World.zones[World.selectedZone!].blocks[index!].red)
			self.greenLevel.value = Float(World.zones[World.selectedZone!].blocks[index!].green)
			self.blueLevel.value = Float(World.zones[World.selectedZone!].blocks[index!].blue)
			self.red = World.zones[World.selectedZone!].blocks[index!].red
			self.green = World.zones[World.selectedZone!].blocks[index!].green
			self.blue = World.zones[World.selectedZone!].blocks[index!].blue
			self.preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.diffuse.contents = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
			self.modifyPreviewZone()
		}
	}
	
	func modifyPreviewZone(){
		if tabs.selectedSegmentIndex == 0 {
			preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial!.diffuse.contents = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
			let index = World.zones[World.selectedZone!].getIndexFromBlock()
			World.zones[World.selectedZone!].blocks[index!].texture = nil
		} else {
			preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.diffuse.contents = UIImage(named: textures[self.selectedTexture!])
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return textures.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("textureCell", forIndexPath: indexPath) as! UICollectionViewCellImage
		let image = UIImage(named: textures[indexPath.row])
		cell.imgView.image = image
		// Configure the cell
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		self.selectedTexture = indexPath.row
		didChange = true
		self.modifyPreviewZone()
		return true
	}
	
	@IBAction func tabsDidChange(sender: AnyObject) {
		
		switch sender.selectedSegmentIndex {
		case 0:
			texturesContainer.hidden = true
			colorsContainer.hidden = false
		case 1:
			texturesContainer.hidden = false
			colorsContainer.hidden = true
			
		default :
			break
		}
	}
}

