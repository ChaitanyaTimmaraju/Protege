//
//  RegistrationViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/13/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import SAConfettiView
class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    
    func alert(_ errorMessage: String)
    {
        let alertController = UIAlertController(title: "Cannot Save", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default ,handler: nil)
        alertController.addAction(okAction)
        self.present(alertController,animated: true,completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Triangle
        
        self.view.addSubview(confettiView)
        self.view.sendSubview(toBack: confettiView)
        confettiView.startConfetti()
        //self.navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let un = username?.text?.stringByRemovingWhitespaces
        let pd = password?.text?.stringByRemovingWhitespaces
        let mail = email?.text?.stringByRemovingWhitespaces
        let phno = mobileNumber?.text?.stringByRemovingWhitespaces
        
        if un?.characters.count != 0 && pd?.characters.count != 0
            && mail?.characters.count != 0 && phno?.characters.count != 0{
            
            let checkUsername = LoginViewController.dbOjbect.triggerDatabase(method: "checkCredentials/\(un!)/\(pd!)")
            let y = checkUsername[0] as! NSDictionary
            let z = Int(y["count(1)"]! as! String)
            
            if  z == 0 {
                LoginViewController.dbOjbect.triggerDatabase(method: "registration/\(un!)/\(pd!)/\(mail!)/\(phno!)")
                self.navigationController?.popViewController(animated: true)
            }else{
                alert("Please select another username")
            }
        }else{
            alert("Please fill all the fields")
        }
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
