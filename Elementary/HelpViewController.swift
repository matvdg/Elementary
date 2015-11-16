//
//  HelpViewController.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 16/05/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    
    // MARK: IBAction
    @IBAction func quit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
	@IBOutlet weak var callOutLabel: UITextView!
	@IBOutlet weak var callOutPageControl: UIPageControl? = UIPageControl()
	@IBAction func callOutPageControlChanged(sender: AnyObject) {
		let selectedPage = self.callOutPageControl?.currentPage
		self.callOutLabel?.text = callOutMsg[selectedPage!]
	}
	
    // MARK: Methods
    var callOutMsg:[String] = []
    var currentMsg:String = String()
    //swipe
    var indexPage = 0
	
	
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.callOutMsg = [
		"Welcome to Elementary! Elementary is a square world in which you can build six zones and create whatever you want. It's a simple 3D construction game. This is the main help page. You can swipe right or left to discover help about the different features of Elementary. Swipe down to dismiss the help page. In the settings page, you can either adjust the sound volume either reset the game. Swipe down to dismiss too.",
			
			"In this main view you can create a zone, edit it or remove it. The planet spins around itself, and you only need to touch a face to select it.  The zone will then automatically be placed in front of you, and the animation will stop. You can also select an area by manually spinning the planet and touching the desired face. Tap again anywhere to restart the animation of the planet. If the zone is empty you must first create it. You must specify the name of the zone (all characters including emoticons are allowed) and a color OR texture, among those the palette offers.",
			
			"In the zone, you can create shapes, edit them with many tools. First of all you must create a new block by touching the + button. Choose between 2D or 3D shapes for your block. Once the block is created, Elementary automatically switches in edition mode, and places it in the center of the world. You can apply a color or texture to any selected block. Just touch the color button and select the color or texture of your choice. At any time, press for detailed information on the i button. You can link a block to another block of another area. For this select the block in question and touch the teleport button. Elementary will automatically display the world in a special mode where you can then select the destination area. Once there, you must touch the destination block. Teleport is now active, and a simple touch on one of both linked blocks will teleport you to the other! The Merge feature allows you to link many blocks. A parent block will be created to link the child blocks. So we can move the parent block at once. To use it, touch the Merge button. An information window reminds you how: touch other blocks then confirm or cancel. The blocks are now merged! Conversely, if a block is already merged but you want to edit child blocks separately (color, texture, rotation, size), use the Unmerge function.",
			
			"Getting around the area : the camera of the zone allows you to change your viewing angle. Touch and drag to tilt the entire zone in the desired axis. Pinch to zoom in / out in the area. Finally perform a rotation gesture to rotate the zone. Gestures in edition mode : you can enable/disable the camera controls with the camera button at the top right of the screen. When the camera is off, you can use your finger to move the block along the X axis or Y axis, and two fingers to move the axis along the Z axis. Pinch to increase / decrease its size, rotate your finger to spin around the Y axis."]
		self.updateTextArea()
		
		//swipe
		//PageControl Swipe
		let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		swipeRight.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(swipeRight)
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		swipeLeft.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(swipeLeft)
		//dismiss
		let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
		swipeDown.direction = UISwipeGestureRecognizerDirection.Down
		self.view.addGestureRecognizer(swipeDown)
  }
  
	
	//swipe
	func respondToSwipeGesture(gesture: UIGestureRecognizer) {
		let totalPage = self.callOutMsg.count
		_ = self.callOutPageControl?.currentPage

		if let swipeGesture = gesture as? UISwipeGestureRecognizer {
			switch swipeGesture.direction {
			case UISwipeGestureRecognizerDirection.Right:
				indexPage--
			case UISwipeGestureRecognizerDirection.Left:
				indexPage++
			case UISwipeGestureRecognizerDirection.Down:
				self.dismissViewControllerAnimated(true, completion: nil)
				
			default:
				break
			}
			indexPage = (indexPage < 0) ? (totalPage - 1):
				indexPage % totalPage
			self.updateTextArea()
			
					}
	}
	
	func updateTextArea() {
		let text = self.callOutLabel
		text.text = callOutMsg[indexPage]
		self.callOutPageControl!.currentPage = indexPage
		text.font = UIFont (name: "Helvetica Neue", size: 16)
		text.textAlignment = NSTextAlignment.Justified
		self.callOutPageControl?.updateCurrentPageDisplay()

	}
	
}