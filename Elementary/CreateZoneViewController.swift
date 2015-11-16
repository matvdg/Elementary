//
//  CreateZoneViewController.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 25/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit

class CreateZoneViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
	
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
	@IBOutlet weak var nameOfZone: UITextField!
	@IBOutlet weak var preview: SCNView!
	@IBOutlet weak var tabs: UISegmentedControl!
	@IBOutlet weak var redLevel: UISlider!
	@IBOutlet weak var greenLevel: UISlider!
	@IBOutlet weak var blueLevel: UISlider!
	
	override func viewDidLoad() {
		self.redLevel.value = Float(self.red)
		self.greenLevel.value = Float(self.green)
		self.blueLevel.value = Float(self.blue)
		preview.allowsCameraControl = true
		super.viewDidLoad()
		texturesContainer.hidden = true
		colorsContainer.hidden = false
		self.initPreviewZone()
		self.textures = createTexture()
	}
	
	override func viewDidAppear(animated: Bool) {
		
		if !World.zones[World.selectedZone!].empty {
			self.nameOfZone.text = World.zones[World.selectedZone!].name
			// reload current color OR texture
			
			if World.zones[World.selectedZone!].textured {
				self.tabs.selectedSegmentIndex = 1
				texturesContainer.hidden = false
				colorsContainer.hidden = true
				preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.diffuse.contents = UIImage(named: World.zones[World.selectedZone!].texture!)
			} else {
				self.tabs.selectedSegmentIndex = 0
				self.redLevel.value = Float(World.zones[World.selectedZone!].red)
				self.greenLevel.value = Float(World.zones[World.selectedZone!].green)
				self.blueLevel.value = Float(World.zones[World.selectedZone!].blue)
				self.red = World.zones[World.selectedZone!].red
				self.green = World.zones[World.selectedZone!].green
				self.blue = World.zones[World.selectedZone!].blue
				self.modifyPreviewZone()
			}
			
		} else {
			
			self.redLevel.value = Float(self.red)
			self.greenLevel.value = Float(self.green)
			self.blueLevel.value = Float(self.blue)
		}
	}
	
	@IBAction func redSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.red = CGFloat(redLevel.value)
		self.modifyPreviewZone()
	}
	
	@IBAction func greenSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.green = CGFloat(greenLevel.value)
		self.modifyPreviewZone()
	}
	
	@IBAction func blueSlider(sender: AnyObject) {
		self.selectedTexture = nil
		didChange = true
		self.blue = CGFloat(blueLevel.value)
		self.modifyPreviewZone()
	}
	
	@IBAction func dismiss(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func createZone(sender: AnyObject) {
		if nameOfZone.text!.isEmpty {
			// create alert controller
			let myAlert = UIAlertController(title: "No man's land:", message: "You must provide a name for your zone", preferredStyle: UIAlertControllerStyle.Alert)
			// add an "OK" button
			myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
			// show the alert
			self.presentViewController(myAlert, animated: true, completion: nil)
		} else {
			// we create the zone either with a color or a texture
			var texture: String? = nil
			if self.selectedTexture != nil {
				texture = self.textures[self.selectedTexture!]
			}
			if didChange || World.zones[World.selectedZone!].empty {
				World.zones[World.selectedZone!].setZone(texture, name: nameOfZone.text!, red: red, green: green, blue: blue)
			} else {
				World.zones[World.selectedZone!].name = nameOfZone.text!
			}
			
			Utils.saveHome()
			self.dismissViewControllerAnimated(true, completion: nil)

		}
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
	
	func createTexture() -> [String] {
		var tab: [String] = []
		for i in 0...14 {
			let name = "g\(i).png"
			tab.append(name)
		}
		return tab
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func initPreviewZone(){
		let floor = SCNBox(width: 1, height: 1, length: 0.000001, chamferRadius: 0.2)
		floor.firstMaterial?.diffuse.contents = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
		floorNode.removeFromParentNode()
		floorNode = SCNNode(geometry: floor)
		floorNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(1, y: 2, z: 3, duration: 10)))
		previewScene.rootNode.addChildNode(floorNode)
		preview.scene = previewScene
	}
	
	func modifyPreviewZone(){
		if tabs.selectedSegmentIndex == 0 {
			preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial!.diffuse.contents = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
		} else {
			preview.scene!.rootNode.childNodes[0].geometry!.firstMaterial?.diffuse.contents = UIImage(named: textures[self.selectedTexture!])
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

class UICollectionViewCellImage: UICollectionViewCell {
	@IBOutlet weak var imgView: UIImageView!
}
