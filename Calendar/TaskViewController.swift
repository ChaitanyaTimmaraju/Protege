//
//  TaskViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/19/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var json:NSMutableArray? = []
    var date:Date?
    var tn:String?
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        tn = taskName?.text?.stringByRemovingWhitespaces
        if tn?.characters.count != 0 {
            date = datePicker.date
            let dateFmt = dateFormat(datePicker: datePicker.date)
            let dbString = "insertCalendarTasks/\(SprialViewController.eventId!)/\(tn!)/\(dateFmt)"
            json = LoginViewController.dbOjbect.triggerDatabase(method: dbString)
            
            self.performSegue(withIdentifier: "unwind", sender: self)
        }
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Task Details"
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dateFormat(datePicker:Date)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: datePicker)
        return formattedDate
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
         print(segue.source)
         if let destination = segue.destination as? ScheduleViewController {
         let id = json?[0]
         let dict:AnyObject = ["date":dateFormat(datePicker:date!),"name":tn,"todoId":"\(id)"] as AnyObject
         destination.tableViewData?.add(dict)
         }*/
        
        //self.navigationController?.popViewController(animated:false)
        
    }
    
    
}
