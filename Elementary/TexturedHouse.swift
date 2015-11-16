import Foundation
import SceneKit

class TexturedHouse {
    
    class func cube() -> SCNGeometry {
        let cube = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        cube.firstMaterial?.diffuse.contents = UIImage(named: "wall")
        cube.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return cube
    }
    
    class func pyramid() -> SCNGeometry {
        let pyramid = SCNPyramid(width: 3.0, height: 2.0, length: 3.0)
        pyramid.firstMaterial?.diffuse.contents = UIImage(named: "roof")
        pyramid.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return pyramid
    }
    
    class func door() -> SCNGeometry {
        let door = SCNBox(width: 0.5, height: 1.0, length: 0.1, chamferRadius: 0.01)
        door.firstMaterial?.diffuse.contents = UIImage(named: "door")
        door.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return door
    }
    
    class func cheminee() -> SCNGeometry {
        let cheminee = SCNBox(width: 0.25, height: 1.0, length: 0.25, chamferRadius: 0.05)
        cheminee.firstMaterial?.diffuse.contents = UIImage(named: "wooden")
        cheminee.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return cheminee
    }
    
    class func window() -> SCNGeometry {
        let window = SCNBox(width: 0.5, height: 0.5, length: 0.1, chamferRadius: 0.01)
        window.firstMaterial?.diffuse.contents = UIImage(named: "window")
        window.firstMaterial?.specular.contents = UIColor.whiteColor()
        
        return window
    }
    
    class func buildHouse() -> SCNNode {
        
        let toitMaison = SCNNode(geometry: TexturedHouse.pyramid())
		toitMaison.setValue(-1, forKey: "id")
        let baseMaison = SCNNode(geometry: TexturedHouse.cube())
		baseMaison.setValue(-1, forKey: "id")

        
        let chemineeMaison = SCNNode(geometry: TexturedHouse.cheminee())
        chemineeMaison.setValue(-1, forKey: "id")
        toitMaison.position = SCNVector3Make(0.0, 1.0, 0.0)
        chemineeMaison.position = SCNVector3Make(0.75, 2.0, 0.0)
        
        let myHouse = SCNNode()
        
        myHouse.addChildNode(baseMaison)
        myHouse.addChildNode(toitMaison)
        myHouse.addChildNode(chemineeMaison)
        
        return myHouse
    }
}

