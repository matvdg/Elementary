//
//  WorldViewController.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 15/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import SceneKit


class WorldViewController: UIViewController {
	// properties
	var worldNode =  SCNNode()
	let cameraNode = SCNNode()
	var currentAngle: Float = 0.0
	// IB outlets
	@IBOutlet weak var areaName: UILabel!
	@IBOutlet weak var world: SCNView!
	@IBOutlet weak var goToZoneOutlet: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var removeButton: UIButton!
	@IBOutlet weak var settingButton: UIButton!
	@IBOutlet weak var helpButton: UIButton!
	
    override func viewDidLoad() {
		Music.playTrack()
        super.viewDidLoad()
		world.backgroundColor = UIColor(white: 0, alpha: 0)
	}
	
	override func viewDidAppear(animated: Bool) {
		world.backgroundColor = UIColor(white: 0, alpha: 0)
		self.world.showsStatistics = false
		self.sceneSetup()
		self.goToZoneOutlet.hidden = true
		self.editButton.hidden = true
		self.removeButton.hidden = true
        
		if Teleport.autoSwitchBackToZone {
			//print("autoSwitch, worldSelected = \(World.selectedZone) ")
			Teleport.autoSwitchBackToZone = false
			Teleport.teleportMode = false
			World.selectedZone = Teleport.teleportFrom
			self.performSegueWithIdentifier("displaySelectedZone", sender: self)
			
		}
        
		if Teleport.teleportMode {
			self.hideButtons(true)
			self.areaName.text = "Touch a world to teleport in"
			self.areaName.hidden = false
			self.helpButton.hidden = true
			self.settingButton.hidden = true
			
        } else if (World.teleportingZoneId != -1) {
          
            self.hideButtons(true)
            self.areaName.hidden = false
            self.helpButton.hidden = true
            self.settingButton.hidden = true
            self.areaName.text = "Going to \(World.zones[World.teleportingZoneId].name)..."
            
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(1)
            //print("teleportingZoneId \(World.teleportingZoneId)")
            self.setNodePosition(World.teleportingZoneId)
            World.selectedZone = World.teleportingZoneId
            
            _ = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: Selector("goToTeleportingZone"), userInfo: nil, repeats: false)
            World.teleportingZoneId = -1
            SCNTransaction.commit()
            
        } else {
            self.helpButton.hidden = false
            self.settingButton.hidden = false
            self.areaName.hidden = false
            self.areaName.text = "Elementary"
			if World.selectedZone != nil {
                //print("pas nil")
                
				self.areaName.text = World.zones[World.selectedZone!].name
				if World.zones[World.selectedZone!].empty == true {
					self.hideButtons(true)
					self.goToZoneOutlet.setTitle("Touch here to create a new zone", forState: UIControlState.Normal)
					self.areaName.hidden = true
					self.goToZoneOutlet.hidden = false
				} else {
					self.goToZoneOutlet.setTitle("Touch here to enter in \(World.zones[World.selectedZone!].name)", forState: UIControlState.Normal)
					self.hideButtons(false)
					self.areaName.hidden = false
					self.goToZoneOutlet.hidden = false
				}
				self.setNodePosition(World.selectedZone!)
				
            } else {
                self.goToZoneOutlet.hidden = true
                self.editButton.hidden = true
                self.removeButton.hidden = true
            }
		}
		
	}
    
    func goToTeleportingZone() {
        self.performSegueWithIdentifier("displaySelectedZone", sender: self)
        self.setNodePosition(World.selectedZone!)
    }
	
	@IBAction func gotoSelectedZone(sender: AnyObject) {
		
		if World.zones[World.selectedZone!].empty == true {
			self.performSegueWithIdentifier("createArea", sender: self)
			
		} else {
			self.performSegueWithIdentifier("displaySelectedZone", sender: self)
			self.setNodePosition(World.selectedZone!)
		}
	}
	
	@IBAction func removeSelectedZone(sender: AnyObject) {
		// create alert controller
		let myAlert = UIAlertController(title: "Warning!", message: "Are you sure to delete \(World.zones[World.selectedZone!].name)? All the data inside the zone will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
		// add an "OK" button
		myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			World.zones[World.selectedZone!].removeZone()
			self.hideButtons(true)
            self.hideButtonClearFace()
		}))
		// add an "Cancel" button
		myAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		// show the alert
		self.presentViewController(myAlert, animated: true, completion: nil)
	}
	
	@IBAction func editSelectedZone(sender: AnyObject) {
		self.performSegueWithIdentifier("createArea", sender: self)
		self.goToZoneOutlet.hidden = true
		self.editButton.hidden = true
		self.removeButton.hidden = true
        
        Utils.saveHome()
	}
	
	func sceneSetup() {
		let scene = SCNScene()
        let zonesLoaded = Utils.loadHome()
        
        //Building the world
        //With or without (you) saved zones
        if zonesLoaded != nil { // Saved (and loaded) zones
            World.zones = zonesLoaded!
            self.worldNode = World.buildWorld(true) // Without New Zones, just load saved zones
        } else {
            self.worldNode = World.buildWorld() // Create new zones
        }
        
        scene.rootNode.addChildNode(worldNode)
        
        if (World.selectedZone == nil) {
            self.rotateWorld()
        }
		
		//Customizing camera
		world.allowsCameraControl = true
		cameraNode.camera = SCNCamera()
		cameraNode.position = SCNVector3Make(0, 0, 3)
		scene.rootNode.addChildNode(cameraNode)
		
		//Customizing lights
		world.autoenablesDefaultLighting = false
		let ambientLightNode = SCNNode()
		ambientLightNode.light = SCNLight()
		ambientLightNode.light?.type = SCNLightTypeAmbient
		ambientLightNode.light?.color = UIColor.whiteColor()
		scene.rootNode.addChildNode(ambientLightNode)
		let omniLightNode = SCNNode()
		omniLightNode.light = SCNLight()
		omniLightNode.light!.type = SCNLightTypeOmni
		omniLightNode.light!.color = UIColor.lightGrayColor()
		omniLightNode.position = SCNVector3Make(50, 50, 50)
		scene.rootNode.addChildNode(omniLightNode)
		world.scene = scene
		
		//add transparency to the background
		world.backgroundColor = UIColor(white: 0, alpha: 0)
		
		// add a pan gesture recognizer
		let panRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
		world.addGestureRecognizer(panRecognizer)

		// add a tap gesture recognizer
		let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
		var gestureRecognizers = [UIGestureRecognizer]()
		gestureRecognizers.append(tapGesture)
		if let existingGestureRecognizers = world.gestureRecognizers {
			gestureRecognizers.appendContentsOf(existingGestureRecognizers)
		}
		world.gestureRecognizers = gestureRecognizers
		
	}
															
	func rotateWorld() {
		self.worldNode.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(5, y: 1, z: 1, duration: 10)), forKey: "rotation")
	}
	
	func displayZones(){
		let vector = cameraNode.rotation
        let _ = worldNode.rotation
		//print("camera \(vector.w)  \(vector.x)    \(vector.y)")
		//print("node \(vectorNode.w)  \(vectorNode.x)    \(vectorNode.y)")
		if vector.w > 1 && vector.w < 3{
			if vector.x > 0.9 {
				areaName.text = World.zones[4].name
			} else if vector.x < -0.9 {
				areaName.text = World.zones[5].name
			} else if vector.y > 0.9 {
				areaName.text = World.zones[3].name
			}else if vector.y < -0.9 {
				areaName.text = World.zones[2].name
			} else {
				areaName.text = World.zones[1].name
			}
		} else if vector.w >= 3 {
			areaName.text = World.zones[0].name
		}
		else {
			areaName.text = World.zones[1].name
		}
	}
	
	func panGesture(sender: UIPanGestureRecognizer) {
		self.hideButtons(true)
        self.worldNode.removeActionForKey("rotation")
        World.selectedZone = nil
        
        //Customizing camera function
		let translation = sender.translationInView(sender.view!)
		let translationX : Float = (Float)(translation.x)
		let translationY : Float = (Float)(translation.y)
		let newAngleX: Float = (Float)(translation.x)*PI/180.0
		let newAngleY: Float = (Float)(translation.y)*PI/180.0
		var newAngle: Float = sqrt(newAngleX*newAngleX + newAngleY*newAngleY)
		let proportion: Float = sqrt(translationX * translationX + translationY * translationY)
		let xProportion = translationX / proportion
		let yProportion = translationY / proportion
		newAngle += currentAngle
		worldNode.transform = SCNMatrix4MakeRotation(newAngle, yProportion, xProportion, 0)
		self.worldNode.removeActionForKey("rotation")

		if (sender.state == UIGestureRecognizerState.Ended){
			currentAngle = newAngle
		}
	}
	
	func setNodePosition(id: Int){
		switch id {
		case 0 :
			cameraNode.pivot = SCNMatrix4MakeRotation(0, 0, 0, 0)
			world.scene?.rootNode.pivot = SCNMatrix4MakeRotation(0, 0, 0, 0)
			worldNode.pivot = SCNMatrix4MakeRotation(0, 0, 0, 0)
			worldNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, PI)
		case 1 :
			worldNode.parentNode?.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
			worldNode.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
		case 2 :
			worldNode.parentNode?.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
			worldNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, -PI/2)
		case 3 :
			worldNode.parentNode?.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
			worldNode.rotation = SCNVector4Make(0.0, 1.0, 0.0, PI/2)
		case 4 :
            worldNode.parentNode?.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
			worldNode.rotation = SCNVector4Make(1.0, 0.0, 0.0, PI/2)
		case 5 :
			worldNode.parentNode?.rotation = SCNVector4Make(0.0, 0.0, 0.0, 0)
			worldNode.rotation = SCNVector4Make(1.0, 0.0, 0.0, -PI/2)
		default :
			break
		}
	}
	
	func handleTap(gestureRecognize: UIGestureRecognizer) {
        self.hideButtonClearFace()

        // check what nodes are tapped
		let p = gestureRecognize.locationInView(world)
		
		let hitResults = world.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            let id: Int  = result.node.valueForKey("id") as! Int
            if Teleport.teleportMode {
                let arrayLinks : [Int:Int]? = World.zones[id].links
                
                if (arrayLinks!.keys.indexOf(Teleport.teleportFrom) != nil) { // Zone already linked
                    let alert = UIAlertController(title: "Warning", message: "This zone is already linked with the previous.\nYou can link zones between themselves only once.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else { // If not linked, ok
                    Teleport.teleportTo = id
                    if Teleport.checkTeleport() {
                        World.selectedZone = id
                        self.performSegueWithIdentifier("displaySelectedZone", sender: self)
                    }
                }
            } else {
                if (id != World.selectedZone) { // If selected zone is newest
                    // get its material
                    let material = result.node!.geometry!.firstMaterial!
                    // highlight it
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(1)
                    material.emission.contents = UIColor.redColor()
                    self.worldNode.removeActionForKey("rotation")
                    self.setNodePosition(id)
                    World.selectedZone = id
                    self.areaName.text = World.zones[World.selectedZone!].name
                    if World.zones[World.selectedZone!].empty == true {
                        self.hideButtons(true)
                        self.goToZoneOutlet.setTitle("Touch here to create a new zone", forState: UIControlState.Normal)
                        self.areaName.hidden = true
                        self.goToZoneOutlet.hidden = false
                    } else {
                        self.goToZoneOutlet.setTitle("Touch here to enter in \(World.zones[World.selectedZone!].name)", forState: UIControlState.Normal)
                        self.hideButtons(false)
                    }
                    SCNTransaction.commit()
                } else {
                    World.selectedZone = nil
                }

            }
        } else { // On a cliqué ailleurs que sur une zone, donc on veut quitter la sélection
            World.selectedZone = nil
        }
		
	}
	
    func hideButtonClearFace(withoutRotate : Bool = false) {
        if (World.selectedZone != nil) {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(2)
            World.zones[World.selectedZone!].node.geometry!.firstMaterial!.emission.contents = UIColor.blackColor()
            SCNTransaction.commit()
        }
        
        self.hideButtons(true)
        
        if (!withoutRotate) {
            self.rotateWorld()
        }
    }
	
	func hideButtons(bool: Bool){
        self.goToZoneOutlet.hidden = bool
        self.editButton.hidden = bool
        self.removeButton.hidden = bool
        self.areaName.hidden = bool
	}


	
}
