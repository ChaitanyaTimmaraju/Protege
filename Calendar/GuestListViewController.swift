//
//  CalendarTableViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/3/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import EVContactsPicker
import Contacts
import ContactsUI
class GuestListViewController: UITableViewController, EVContactsPickerDelegate {
    var store : CNContactStore? = nil
    var tempData:[EVContactProtocol]?
    var tableViewData:NSMutableArray? = []
    var vendorsData:NSMutableArray? = []
    var guestsInvited = [Int]()
    var vendorsCalled = [Int]()
    
    var dbString = ""
    let sectionHeaders = ["Guest-List","Vendors"]
    @IBAction func AddGuests(_ sender: UIBarButtonItem) {
        showPicker()
    }
    func showPicker() {
        let contactPicker = EVContactsPickerViewController()
        contactPicker.delegate = self
        self.navigationController?.pushViewController(contactPicker, animated: true)
    }
    func guestActionHandler(alert: UIAlertAction!) {
        // Do something...
        
        if let cons = tempData {
            for con in cons {
                let dict:AnyObject = ["identifier":con.identifier,"invited":"0"] as AnyObject
                if !(tableViewData?.contains(dict))! {
                    dbString.append("/\(con.identifier)")
                    tableViewData?.add(dict)
                    guestsInvited.append(0)
                    
                    
                }
            }
        }
        if dbString.characters.count != 0{
            self.tableView.reloadData()
            LoginViewController.dbOjbect.triggerDatabase(method: "insertContacts/\(SprialViewController.eventId!)/\(0)/\(dbString)")
            print(dbString)
        }
        
    }
    func vendorActionHandler(alert: UIAlertAction!) {
        // Do something...
        if let cons = tempData {
            for con in cons {
                let dict:AnyObject = ["identifier":con.identifier,"invited":"0"] as AnyObject
                if !(vendorsData?.contains(dict))! {
                    dbString.append("/\(con.identifier)")
                    vendorsData?.add(dict)
                    vendorsCalled.append(0)
                    
                    
                }
            }
        }
        if dbString.characters.count != 0{
            self.tableView.reloadData()
            print(dbString)
            
            LoginViewController.dbOjbect.triggerDatabase(method: "insertVendors/\(SprialViewController.eventId!)/\(0)/\(dbString)")
        }
    }
    func alert()
    {
        let alertController = UIAlertController(title: "Add the contacts to which one?", message:"", preferredStyle: .alert)
        let vendorAction = UIAlertAction(title: "Venodrs", style:.default ,handler: vendorActionHandler)
        let guestAction =  UIAlertAction(title: "Guests", style:.default ,handler: guestActionHandler)
        alertController.addAction(vendorAction)
        alertController.addAction(guestAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    
    func didChooseContacts(_ contacts: [EVContactProtocol]?) {
        dbString = ""
        tempData = contacts
        self.navigationController?.popViewController(animated: true)
        alert()
    }
    
    func fetchDetails(id:String)
    {
        do {
            let appconact = try self.store?.unifiedContact(withIdentifier: (id), keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] )
            print(appconact?.givenName)
            let vc = CNContactViewController(for: appconact!)
            CNContactViewController.descriptorForRequiredKeys()
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            print("error")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  isMovingToParentViewController == true
        {
            var index = 0
            dbString = ""
            for x in tableViewData!
            {
                
                let record = x as! NSDictionary
                let invited = Int(record["invited"] as! String)
                if guestsInvited[index] != invited
                {
                    let id = (record["identifier"] as! String)
                    dbString.append("\(id)/\(guestsInvited[index])/")
                }
                index = index + 1
            }
            if dbString.characters.count > 0 {
                LoginViewController.dbOjbect.triggerDatabase(method: "modifyInvitations/\(SprialViewController.eventId!)/\(dbString)")
            }
            index = 0
            dbString = ""
            for x in vendorsData!
            {
                let record = x as! NSDictionary
                let invited = Int(record["invited"] as! String)
                if vendorsCalled[index] != invited
                {
                    let id = (record["identifier"] as! String)
                    dbString.append("\(id)/\(vendorsCalled[index])/")
                }
                index = index + 1
            }
            if dbString.characters.count > 0 {
                LoginViewController.dbOjbect.triggerDatabase(method: "modifyVendors/\(SprialViewController.eventId!)/\(dbString)")
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.store = CNContactStore()
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveContacts/\(SprialViewController.eventId!)")
        vendorsData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveVendors/\(SprialViewController.eventId!)")
        for x in tableViewData!
        {
            let record = x as! NSDictionary
            let invited = Int(record["invited"] as! String)
            guestsInvited.append(invited!)
            
            
        }
        for x in vendorsData!
        {
            let record = x as! NSDictionary
            let invited = Int(record["invited"] as! String)
            vendorsCalled.append(invited!)
            
            
        }
        print(guestsInvited)
        self.tableView.reloadData()
        // showPicker()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return (tableViewData?.count)!
        }else{
            return (vendorsData?.count)!
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestListTableCell", for: indexPath)
        do {
            let record = indexPath.section == 0 ?  tableViewData?[indexPath.row] as! NSDictionary :  vendorsData?[indexPath.row] as! NSDictionary
            let id = (record["identifier"] as! String)
            let invited = indexPath.section == 0 ? guestsInvited[indexPath.row] : vendorsCalled[indexPath.row]
            let appContact = try self.store?.unifiedContact(withIdentifier: (id), keysToFetch: [CNContactViewController.descriptorForRequiredKeys()] )
            cell.textLabel?.text =  appContact?.givenName
            if (appContact?.emailAddresses.count)! > 0 {
                print(appContact?.emailAddresses[0])
                cell.detailTextLabel?.text = appContact?.emailAddresses[0].value as! String
            }else {
                cell.detailTextLabel?.text = ""
            }
            print(invited)
            if invited > 0{
                cell.backgroundColor = UIColor.green
                cell.accessoryType = .checkmark
            }
            
        } catch {
            print("error")
        }
        return cell
    }
    
    override func tableView(_: UITableView, accessoryButtonTappedForRowWith: IndexPath) {
        
        let record = accessoryButtonTappedForRowWith.section == 0 ? tableViewData?[accessoryButtonTappedForRowWith.row] as! NSDictionary : vendorsData?[accessoryButtonTappedForRowWith.row] as! NSDictionary
        let id = (record["identifier"] as! String)
        fetchDetails(id: id)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let record = tableViewData?[indexPath.row] as! NSDictionary
                let id = (record["identifier"] as! String)
                guestsInvited.remove(at: indexPath.row)
                tableViewData?.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                LoginViewController.dbOjbect.triggerDatabase(method: "deleteContact/\(SprialViewController.eventId!)/\(id)")
            }else{
                let record = vendorsData?[indexPath.row] as! NSDictionary
                let id = (record["identifier"] as! String)
                vendorsCalled.remove(at: indexPath.row)
                vendorsData?.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                LoginViewController.dbOjbect.triggerDatabase(method: "deleteVendor/\(SprialViewController.eventId!)/\(id)")
            }
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let invited = indexPath.section == 0 ? guestsInvited[indexPath.row] : vendorsCalled[indexPath.row]
        if indexPath.section == 0{
            if invited == 0 {
                guestsInvited[indexPath.row] = 1
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }else{
                guestsInvited[indexPath.row] = 0
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
                tableView.cellForRow(at: indexPath)?.accessoryType = .detailButton
            }
        }
        else {
            if invited == 0 {
                vendorsCalled[indexPath.row] = 1
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }else{
                vendorsCalled[indexPath.row] = 0
                tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
                tableView.cellForRow(at: indexPath)?.accessoryType = .detailButton
            }
        }
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
