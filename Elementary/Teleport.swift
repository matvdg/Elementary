//
//  Teleport.swift
//  Elementary
//
//  Created by Mathieu Vandeginste on 14/06/15.
//  Copyright (c) 2015 Supinfo. All rights reserved.
//

import UIKit

class Teleport {
	static var teleportMode: Bool = false
	static var teleportTo: Int = 0
	static var teleportFrom: Int = 0
	static var autoSwitchBackToZone: Bool = false
	static var teleportFromBlockId: Int = -1
	
	//TODO : imbriquer checkTeleport pour une zone DANS canTeleport pour éviter redondance ET vérifiez les conditions MERGE (empêchant le linking) ET zone destination déjà linkée à la zone source (pour l'instant on ne vérifie que si la zone n'est pas vierge, contient des blocs, et que le nombres de liens est différent du nombres de blocs pour qu'il y ait des blocs disponibles, OR ils peuvent être disponibles mais non compatible à la téléportation si mergés ou si zone Destination déjà linkée à la zone Source)
	
	static func checkTeleport() -> Bool {
		// check if the rules of teleportation are OK
		if teleportTo == teleportFrom || World.zones[teleportTo].empty == true {
			return false
		} else {
            let blocksLoaded = Utils.loadZone(teleportTo)
            
            if blocksLoaded != nil { // Saved (and loaded) blocks
                World.zones[teleportTo].blocks = blocksLoaded!
            }
            
            var nbreMerged = 0
            let nbreBlocks = blocksLoaded?.count
            
            for block in World.zones[teleportTo].blocks {
                if (block.merge.count != 0) {
                    nbreMerged++
                }
            }
            
            //print("zone = \(zone.id), counter = \(zone.counter)")
            
            // If less merged blocks, blocks > 0, and blocks dispo
            if nbreMerged < nbreBlocks && World.zones[teleportTo].blocks.count > 0 && World.zones[teleportTo].links.count != World.zones[teleportTo].blocks.count {
                return true
            } else {
                return false
            }
		}
	}
	
	static func canTeleport() -> Bool {
		// check if teleportation is available
		teleportFrom = World.selectedZone!
        
		var answer = false
		for zone in World.zones {
            let arrayLinks : [Int:Int]? = zone.links
            
            if zone.id != teleportFrom && arrayLinks!.keys.indexOf(teleportFrom) == nil { // Zone not itself or not linked
                let blocksLoaded = Utils.loadZone(zone.id)
                
                if blocksLoaded != nil { // Saved (and loaded) blocks
                    World.zones[zone.id].blocks = blocksLoaded!
                }
                
                var nbreMerged = 0
                let nbreBlocks = blocksLoaded?.count
                
                print("Zone \(zone.id) - nbreMerged \(nbreMerged) - nbreBlock \(nbreBlocks)")
                
                for block in World.zones[zone.id].blocks {
                    if (block.merge.count != 0) {
                        nbreMerged++
                    }
                }
                
                //print("zone = \(zone.id), counter = \(zone.counter)")
                if nbreMerged < nbreBlocks && zone.blocks.count > 0 && zone.links.count != zone.blocks.count { // if they are blocks available for teleport
					answer = true
                }
			}
		}

        if World.zones[World.selectedZone!].links.count == 5 {
            // If number of links is 5 (full), we can't
            answer = false
        }
        
		return answer
	}
	
	static func saveTeleport() {
		// we save the teleport link
		World.zones[teleportFrom].links[teleportTo] = Teleport.teleportFromBlockId
		World.zones[teleportTo].links[teleportFrom] = World.zones[teleportTo].selectedBlock
		Utils.saveHome()
        
        //print(World.zones[teleportTo])
		//print(World.zones[teleportFrom].links)
		//print(World.zones[teleportTo].links)

	}
	
	
}
