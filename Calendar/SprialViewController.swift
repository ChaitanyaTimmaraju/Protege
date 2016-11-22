//
//  SprialViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import CircleMenu
import Toaster
extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}
class SprialViewController: UIViewController,CircleMenuDelegate{

    var anim = true
 
    static var eventId:Int?
    static var event:NSDictionary?
    let items: [(icon: UIImage, color: UIColor)] = [
        (#imageLiteral(resourceName: "Menu"), UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        (#imageLiteral(resourceName: "Schedule"), UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        (#imageLiteral(resourceName: "Budget"), UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        (#imageLiteral(resourceName: "Settings"), UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        (#imageLiteral(resourceName: "Guest"), UIColor(red:1, green:0.39, blue:0, alpha:1)),
        //("nearby-btn", UIColor(red:1, green:0.39, blue:0, alpha:1))
        ]
    var button:CircleMenu?;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // add button
        
                 button = CircleMenu(
                    frame: CGRect(x: 200, y: 200, width: 80, height: 80),
                    normalIcon:"Main.png",
                    selectedIcon:"Main.png",
                    buttonsCount: 5,
                    duration: 0.6,
                    distance: 170)
                button?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button?.delegate = self
        
                button?.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
                button?.layer.cornerRadius = (button?.frame.size.width)! / 2.0
                view.addSubview(button!)
    
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.repeat , .autoreverse , .allowUserInteraction], animations: {
            
            
            self.view.transform = CGAffineTransform(scaleX:3.0 , y: 3.0)
            }, completion: { (finished) -> Void in
                
            }
        )
        Toast(text: "Tap to see options.").show()
        anim = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       //  button?.sendActions(for: .touchUpInside)
      
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if button.isEnabled == true && anim == true{
            self.view.layer.removeAllAnimations()
            self.view.transform =  CGAffineTransform(scaleX:1.0    , y: 1.0)
            anim = false
        }
        button.backgroundColor = items[atIndex].color
        button.setImage(items[atIndex].icon, for: .normal)
        // set highlited image
        let highlightedImage  =  items[atIndex].icon.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
      
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
       // print("button did selected: \(atIndex)")
        switch atIndex {
        case 1: performSegue(withIdentifier: "CalendarSegue", sender: nil)
        case 4:performSegue(withIdentifier: "ContactsSegue", sender: nil)
        case 2:performSegue(withIdentifier: "BudgetSegue", sender: nil)
        case 3:performSegue(withIdentifier: "VenueSegue", sender: nil)
        //case 0:performSegue(withIdentifier: "MenuSegue", sender: nil)
        default:
            return
        }
        
    }
    func menuCollapsed(_ circleMenu: CircleMenu) {
        
        anim = true
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.repeat , .autoreverse , .allowUserInteraction], animations: {

            self.view.transform = CGAffineTransform(scaleX:3.0 , y: 3.0)
            }, completion: { (finished) -> Void in
                
            }
        )

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
