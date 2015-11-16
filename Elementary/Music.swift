//
//  Music.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 14/06/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit
import AVFoundation

class Music {
	static var player: AVAudioPlayer?
	class func playTrack() {
		
		let mediapath = "elementary"
		
		if let path = NSBundle.mainBundle().pathForResource(mediapath, ofType: "mp3") {
			try! player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
			player?.numberOfLoops = -1
			player?.prepareToPlay()
			player?.play()
		}
	}
	
	
	class func adjustVolume(value: Float) {
		player?.volume = value

	}
}

