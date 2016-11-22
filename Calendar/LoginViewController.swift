//
//  LoginViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined(separator: "")
    }
}
class LoginViewController: UIViewController {
    
    static let dbOjbect = DatabaseManagement()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var plistURL:URL!
    var myPlist:NSMutableDictionary!
    var un:String?
    static var uname:String?
    @IBAction func logIn(_ sender: UIButton) {
        un = username?.text?.stringByRemovingWhitespaces
        let pd = password?.text?.stringByRemovingWhitespaces
        
        if un?.characters.count != 0 && pd?.characters.count != 0 {
            let x = LoginViewController.dbOjbect.triggerDatabase(method: "checkCredentials/\(un!)/\(pd!)")
            let y = x[0] as! NSDictionary
            let z = Int(y["count(1)"]! as! String)
            if  z != 0 {
                self.myPlist.setValue(un, forKey: "uname")
                self.myPlist.write(to: self.plistURL, atomically: true)
                
                performSegue(withIdentifier: "LogInSegue", sender: nil)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = urls[0]
        plistURL = documentDir.appendingPathComponent("USERINFO.plist")
        myPlist = NSMutableDictionary(contentsOf: plistURL)
        if myPlist == nil {      let bundleURL = Bundle.main.url(forResource: "USERINFO",withExtension: "plist");      do {         try FileManager.default.copyItem(at: bundleURL!, to: plistURL)      } catch {        print("Error copying property list: \(error)")      }
            myPlist = NSMutableDictionary(contentsOf:plistURL)    }
        
        let plistUname = myPlist["uname"] as! String
        if plistUname.characters.count != 0 {
            un = plistUname
            self.performSegue(withIdentifier: "LogInSegue", sender: self)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        password.text = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is EventsTableViewController {
            LoginViewController.uname = un
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
    
}
