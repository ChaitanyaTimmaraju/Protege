//
//  EventDetailsViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
class EventDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var budget: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let en = eventName?.text?.stringByRemovingWhitespaces
        let loc = location?.text?.stringByRemovingWhitespaces
        let bud = budget?.text?.stringByRemovingWhitespaces
        
        if en?.characters.count != 0 && loc?.characters.count != 0
            && bud?.characters.count != 0{
            let dt = dateFormat(datePicker: datePicker.date)
            let startDate = dateFormat(datePicker: Date())
            let dbString = "insertEvent/\(LoginViewController.uname!)/\(en!)/\(loc!)/\(dt)/\(bud!)/\(startDate)"
            LoginViewController.dbOjbect.triggerDatabase(method: dbString)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        datePicker.minimumDate = Date()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateFormat(datePicker:Date)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: datePicker)
        return formattedDate
    }
    
    
    // MARK: - Navigation
    
    /*// In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let dst = segue.destination as? EventsTableViewController{
     print("called")
     dst.retriveData()
     }
     }*/
    
    
}
