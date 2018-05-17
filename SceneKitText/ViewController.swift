//:# SceneKitText - a Demonstration of Scene Kit 3d Text
//: Steven Lipton May 2018
import UIKit
import SceneKit
//:Uncomment this line and the lines at bottom of code to run in playgrounds.
//import PlaygroundSupport

class ViewController:UIViewController {
    //The Scene
    var sceneView =  SCNView()
    
    // Scene kit scene, camera and light
    let scene = SCNScene()
    
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    
    let lightNode = SCNNode()
    let light = SCNLight()
    
    var textNode = SCNNode()
    
    //The labels for the sliders
    var labelX = UILabel()
    var labelY = UILabel()
    var labelZ = UILabel()
    var labelYRot = UILabel()
    
    //The sliders
    var sliderZ = UISlider()
    var sliderY = UISlider()
    var sliderX = UISlider()
    var sliderYRot = UISlider()
    
    
    
    
    @IBAction func rotSlidersDidChange(_ sender: UISlider) {
        let rotation = sender.value * 2.0 * .pi
        labelYRot.text = String(format:"%2.2f",sender.value)
        textNode.eulerAngles = SCNVector3( textNode.eulerAngles.x, rotation,textNode.eulerAngles.z)
    }
    
    // Single action to change the slider position value
    
    @IBAction func slidersDidChange(_ sender: UISlider){
        
        labelX.text = String(format:"%2.2f",sliderX.value)
        labelY.text = String(format:"%2.2f",sliderY.value)
        labelZ.text = String(format:"%2.2f",sliderZ.value)
        cameraNode.position = SCNVector3Make(sliderX.value
            , sliderY.value, sliderZ.value)
    }
    
    
    
    func makeScene(){
        
        //Set up the scene
        sceneView.backgroundColor = .gray
        sceneView.scene = scene
        
        //Add the camera node. Values are from the sliders
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        //Add lighting
        light.type = .directional
        lightNode.light = light
        lightNode.position = SCNVector3Make(1.5, 1.5, 1.5)
        scene.rootNode.addChildNode(lightNode)
        
        // Do your work here
        let pizzaGeometry = SCNText(string: "Pizza", extrusionDepth: 0.5)
        pizzaGeometry.font = UIFont(name: "AvenirNext-Heavy", size: 1.0)
        pizzaGeometry.firstMaterial?.diffuse.contents = UIColor.red
        pizzaGeometry.firstMaterial?.specular.contents = UIColor(red: 0.4, green: 0.9, blue: 0.3, alpha: 1.0)
        pizzaGeometry.flatness = 0.1
        pizzaGeometry.chamferRadius = 0.05
        
        
        
        
        textNode = SCNNode(geometry: pizzaGeometry)
        scene.rootNode.addChildNode(textNode)
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .gray
        layoutView()
        makeScene()
        slidersDidChange(sliderZ)
        rotSlidersDidChange(sliderYRot)
    }
    
    func layoutView(){
        
        //Using the Visual format Language for this. See the Programmatic Autolayout iOS 11 course for more.
        
        //make the dictionary of views
        let views:[String:Any] = [
            "sceneView":sceneView,
            "sliderX":sliderX,
            "sliderY":sliderY,
            "sliderZ":sliderZ,
            "sliderYRot":sliderYRot,
            "labelX":labelX,"labelY":labelY,"labelZ":labelZ,
            "labelYRot":labelYRot
        ]
        
        //a template for the horizontal layout of sliders and labels
        func hLayoutString(identifier:String)->String{
            return "H:|-10-[slider"+identifier+"]-20-[label"+identifier+"]-10-|"
        }
        
        //returns the slider or label from the views dictionary
        func slider(_ identifier:String)->UISlider{
            return views["slider"+identifier] as! UISlider
        }
        func label(_ identifier:String)->UILabel{
            return views["label"+identifier] as! UILabel
        }
        // add and configure the views
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelX)
        labelX.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelY)
        labelY.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelZ)
        labelZ.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelYRot)
        labelYRot.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderX)
        sliderX.maximumValue = 5.0
        sliderX.minimumValue = -2.0
        sliderX.value = 1.5
        sliderX.translatesAutoresizingMaskIntoConstraints = false
        sliderX.addTarget(self, action: #selector(slidersDidChange(_:)), for: .valueChanged)
        view.addSubview(sliderY)
        sliderY.maximumValue = 5.0
        sliderY.minimumValue = -2.0
        sliderY.value = 1.5
        sliderY.translatesAutoresizingMaskIntoConstraints = false
        sliderY.addTarget(self, action: #selector(slidersDidChange(_:)), for: .valueChanged)
        view.addSubview(sliderZ)
        sliderZ.maximumValue = 10.0
        sliderZ.minimumValue = 0.0
        sliderZ.value = 5.0
        sliderZ.translatesAutoresizingMaskIntoConstraints = false
        sliderZ.addTarget(self, action: #selector(slidersDidChange(_:)), for: .valueChanged)
        view.addSubview(sliderYRot)
        sliderYRot.maximumValue = 1.0
        sliderYRot.minimumValue = 0.0
        sliderYRot.value = 0
        sliderYRot.translatesAutoresizingMaskIntoConstraints = false
        sliderYRot.addTarget(self, action: #selector(rotSlidersDidChange(_:)), for: .valueChanged)
        
        // layout the views
        var constraints = [NSLayoutConstraint]()
        //layout sceneview
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[sceneView]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
        
        //make the sliders next to the label with a 5:3 width ratio.
        //since this is repetitive for a slider and label, I used a loop.
        let horizontalLayoutIdentifiers = ["X","Y","Z","YRot"]
        for identifier in horizontalLayoutIdentifiers{
            constraints += NSLayoutConstraint.constraints(withVisualFormat: hLayoutString(identifier: identifier), options: .alignAllCenterY, metrics: nil, views: views)
            constraints += [NSLayoutConstraint.init(
                item:slider(identifier),attribute: .width,relatedBy: .equal,toItem: label(identifier),attribute: .width,multiplier: 5/3,constant: 0.0)]
        }
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[sceneView]-8-[sliderX]-8-[sliderY]-8-[sliderZ]-8-[sliderYRot]-20-|", options: .alignAllLeading, metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
//: Uncomment this code to run in a playground. Compatible with v2.1 iPad playgrounds bug. See http://bit.ly/iPad21Bug for details.
/*
class StartViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        present(ViewController(), animated: false, completion: nil)
    }
}
PlaygroundPage.current.liveView = StartViewController()
*/

