//
//  ViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit
import Toaster
class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var categoriesTable: UITableView!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    var tableViewData:NSMutableArray? = []
    var spent = 0
    var _amount = 0
    @IBAction func addCategory(_ sender: UIButton) {
     setCategory()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Line 29 - EventKeys: \(SprialViewController.event?.allKeys)")
        
           _amount = Int(SprialViewController.event?["budget"]! as! String)!
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveCategories/\(SprialViewController.eventId!)")
        for x in tableViewData! {
            let y = x as! NSDictionary
            let budget = Int(y["budget"] as! String)
            spent = spent + budget!
        }
     
        setLables()
    }
    func setLables()
    {
      
        spentLabel.text = "\(spent)"
        remainingLabel.text = "\(_amount - spent)"
        budgetLabel.text = "\(_amount)"
    }
    func setCategory() {
        let alertController = UIAlertController(title: "Create category", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
        let whitespaces = NSCharacterSet.whitespaces
            
            // Check if a field is empty
            if alertController.textFields?[0].text?.trimmingCharacters(in: whitespaces) == "" || alertController.textFields?[1].text == "" {
                
                let alert = UIAlertController(title: "Cannot Save", message: "One of the fields were empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                
                // Name does not need to be checked
                let name: String = (alertController.textFields?[0].text?.stringByRemovingWhitespaces)!
                
                // Make sure Budget text field is a float.
                if let budget: Int = Int((alertController.textFields?[1].text)!) {
                    if (self._amount - self.spent - budget) > 0
                    {
                    let x =  LoginViewController.dbOjbect.triggerDatabase(method: "insertCategory/\(SprialViewController.eventId!)/\(budget)/\(name)")
                    
                    let dict:AnyObject = ["main_Id":SprialViewController.eventId!,"budget":"\(budget)","name":"\(name)","catId":"\(x[0])"] as AnyObject
                    self.spent = self.spent + budget
                    self.setLables()
                    self.tableViewData?.add(dict)
                    self.categoriesTable.reloadData()
                    }else{
                         Toast(text: "You cannot add another category.\n Stay on ground.", delay: 0.0, duration: 2.5).show()
                    }
                }
                else {
                    let alert = UIAlertController(title: "Cannot Save", message: "Budget field not a valid entry", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Category name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Budget Amount: $0.00"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
     // Mark: TableView Management
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableViewData?.count)!
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ruid", for: indexPath)
        let y = tableViewData?[indexPath.row] as! NSDictionary
        let name = (y["name"] as! String)
        let date = y["budget"] as! String
        cell.textLabel?.text =  name
        cell.detailTextLabel?.text = date
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let y = tableViewData?[indexPath.row] as! NSDictionary
            let id = (y["catId"] as! String)
            let budg = Int(y["budget"] as! String)
            LoginViewController.dbOjbect.triggerDatabase(method: "deleteCategories/\(id)")
            tableViewData?.removeObject(at: indexPath.row)
            spent = spent - budg!
            setLables()
            categoriesTable.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
    // Mark: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoryViewController
            {
            let y = tableViewData?[(categoriesTable.indexPathForSelectedRow?.row)!] as! NSDictionary
                let cat = y["catId"] as! String
             vc.catId = Int(cat)
                let bat = y["budget"] as! String
             vc._amount = Int(bat)
                print(vc.catId)
               
        }
   
    }
    
}
    
