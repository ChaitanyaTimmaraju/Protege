//
//  EventsTableViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/13/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    var tableViewData:NSMutableArray? = []
    @IBAction func logout(_ sender: UIBarButtonItem) {
        alert()
        
    }
    func alert()
    {
        
        let alertController = UIAlertController(title: "Logout", message:"Remove \"\(LoginViewController.uname!)\"  from instant login?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style:.destructive ,handler: confirmActionHandler)
        let guestAction =  UIAlertAction(title: "Cancel", style:.default ,handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(guestAction)
        self.present(alertController,animated: true,completion: nil)
    }
    func confirmActionHandler(action:UIAlertAction){
        var plistURL:URL!
        var myPlist:NSMutableDictionary!
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = urls[0]
        plistURL = documentDir.appendingPathComponent("USERINFO.plist")
        myPlist = NSMutableDictionary(contentsOf: plistURL)
        if myPlist == nil {      let bundleURL = Bundle.main.url(forResource: "USERINFO",withExtension: "plist");      do {         try FileManager.default.copyItem(at: bundleURL!, to: plistURL)      } catch {        print("Error copying property list: \(error)")      }
            myPlist = NSMutableDictionary(contentsOf:plistURL)    }
        myPlist.setValue("", forKey: "uname")
        myPlist.write(to: plistURL, atomically: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func retriveData()
    {
        
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "retriveEvents/\(LoginViewController.uname!)")
        
        
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //self.navigationItem.backBarButtonItem?.title = ""
        // self.navigationController?.title = "Events"
        //self.navigationController?.navigationBar.backItem?.title = "Events"
        retriveData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return (tableViewData?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let y = tableViewData?[indexPath.row] as! NSDictionary
        let name = (y["name"] as! String)
        let date = y["date"] as! String
        cell.textLabel?.text =  name
        cell.detailTextLabel?.text = date
        
        return cell
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
            // Delete the row from the data source
            let retrivedRow = tableViewData?[indexPath.row] as! NSDictionary
            let id = (retrivedRow["eventId"] as! String)
            LoginViewController.dbOjbect.triggerDatabase(method: "deleteEvent/\(id)")
            tableViewData?.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.destination is SprialViewController {
            self.navigationItem.setHidesBackButton(false, animated: true)
            
            let retrivedRow  = tableViewData?[(self.tableView.indexPathForSelectedRow!.row)] as! NSDictionary
            let id = (retrivedRow["eventId"] as! String)
            SprialViewController.event = retrivedRow
            SprialViewController.eventId = Int(id)
        }
        
    }
    
    
}
