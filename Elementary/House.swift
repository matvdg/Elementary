import Foundation
import SceneKit

class House {
    
    class func cube() -> SCNGeometry {
        let cube = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        cube.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        cube.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return cube
    }
    
    class func pyramid() -> SCNGeometry {
        let pyramid = SCNPyramid(width: 3, height: 2, length: 3)
        pyramid.firstMaterial?.diffuse.contents = UIColor.redColor()
        pyramid.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return pyramid
    }
    
    class func door() -> SCNGeometry {
        let door = SCNBox(width: 0.5, height: 1, length: 0.1, chamferRadius: 0.01)
        door.firstMaterial?.diffuse.contents = UIColor.brownColor()
        door.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return door
    }
	
    
    class func cheminee() -> SCNGeometry {
        let cheminee = SCNBox(width: 0.25, height: 1, length: 0.25, chamferRadius: 0.05)
        cheminee.firstMaterial?.diffuse.contents = UIColor.darkGrayColor()
        cheminee.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return cheminee
    }
    
    class func window() -> SCNGeometry {
        let window = SCNBox(width: 0.5, height: 0.5, length: 0.1, chamferRadius: 0.01)
        window.firstMaterial?.diffuse.contents = UIColor.blueColor()
        window.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return window
    }
    
    class func buildHouse() -> SCNNode {
        let toitMaison = SCNNode(geometry: House.pyramid())
        let porteMaison = SCNNode(geometry: House.door())
        let baseMaison = SCNNode(geometry: House.cube())
        let fenetreMaison1 = SCNNode(geometry: House.window())
        let fenetreMaison2 = SCNNode(geometry: House.window())
        
        let chemineeMaison = SCNNode(geometry: House.cheminee())
        
        baseMaison.position = SCNVector3Make(0, 0, 0)
        toitMaison.position = SCNVector3Make(0, 1, 0)
        fenetreMaison1.position = SCNVector3Make(0.6, 0.4, 1)
        fenetreMaison2.position = SCNVector3Make(-0.6, 0.4, 1)
        porteMaison.position = SCNVector3Make(0, -0.5, 1)
        chemineeMaison.position = SCNVector3Make(0.75, 2, 0)
        
        let myHouse = SCNNode()
        
        myHouse.addChildNode(baseMaison)
        myHouse.addChildNode(toitMaison)
        myHouse.addChildNode(porteMaison)
        myHouse.addChildNode(fenetreMaison1)
        myHouse.addChildNode(fenetreMaison2)
        myHouse.addChildNode(chemineeMaison)
        
        return myHouse
    }
}

