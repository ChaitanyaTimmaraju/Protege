//
//  CategoryViewController.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit
import Toaster
class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var tableViewData:NSMutableArray? = []
    var spent = 0
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var itemsTable: UITableView!
    var catId:Int?
    var _amount:Int?
    @IBAction func addItem(_ sender: UIButton) {
        setItem()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveItems/\(self.catId!)")
        for x in tableViewData! {
            let y = x as! NSDictionary
            let budget = Int(y["cost"] as! String)
            spent = spent + budget!
        }
        
        setLables()
       
    }
    func setLables()
    {
        spentLabel.text = "\(spent)"
        remainingLabel.text = "\(_amount! - spent)"
        budgetLabel.text = "\(_amount!)"
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
        let cost = y["cost"] as! String
        cell.textLabel?.text =  name
        cell.detailTextLabel?.text = cost
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let y = tableViewData?[indexPath.row] as! NSDictionary
            let name = (y["name"] as! String)
            let budg = Int(y["cost"] as! String)
            LoginViewController.dbOjbect.triggerDatabase(method: "deleteItems/\(catId!)/\(name)")
            tableViewData?.removeObject(at: indexPath.row)
            spent = spent - budg!
            setLables()
            itemsTable.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
 
    
    func setItem() {
        let alertController = UIAlertController(title: "Create Item", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            
            // Grab form values
            let name: String = (alertController.textFields?[0].text?.stringByRemovingWhitespaces)!
            let cost: String = (alertController.textFields![1].text?.stringByRemovingWhitespaces)!
           
            if cost.characters.count != 0 && name.characters.count != 0 {
               
                if (self._amount! - self.spent - Int(cost)!) > 0
                {
                let dict:AnyObject = ["catId":"\(self.catId!)","cost":"\(cost)","name":"\(name)"] as AnyObject
                var boolean = true;
           
                for x in self.tableViewData! {
                    let y = x as! NSDictionary
                    let nm = (y["name"] as! String)
                    if nm == name {
                        boolean = false;
                        break;
                    }
                    
                    
                }
                
                if boolean == true
                {
                        let retrivedId = LoginViewController.dbOjbect.triggerDatabase(method: "insertItems/\(self.catId!)/\(cost)/\(name)")
                        self.spent = self.spent + Int(cost)!
                        self.setLables()
                        self.tableViewData?.add(dict)
                        self.itemsTable.reloadData()
                }
            
                }else {
                    Toast(text: "You cannot buy this.\nSorry EXCEEDING LIMIT!!!", delay: 0.0, duration: 2.5).show()
                }
            }else{
                let alert = UIAlertController(title: "Cannot Save", message: "One of the fields were empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
          

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Item name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Amount: $0.00"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
