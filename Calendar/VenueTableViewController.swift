//
//  VenueTableViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import DataEntryToolbar

class VenueTableViewController: UITableViewController {
    
    let sectionHeaders = ["Personal Info","Event Info"]
    let myDataSource = [
        ["Name","Username", "Password", "Email"],
        ["Event Name", "Budget", "Date","Location","Remaining Days","Guests Invited","Vendors contacted"]
    ]
    let myImages = [
        [#imageLiteral(resourceName: "Name"),#imageLiteral(resourceName: "User"),#imageLiteral(resourceName: "Password"),#imageLiteral(resourceName: "Email")],
        [#imageLiteral(resourceName: "Event"),#imageLiteral(resourceName: "Budget"),#imageLiteral(resourceName: "Date"),#imageLiteral(resourceName: "Location"),#imageLiteral(resourceName: "Remaining"),#imageLiteral(resourceName: "Invitation"),#imageLiteral(resourceName: "Vendor")]]
    var myDetailDatatSource = [[],[]]
    
    func stngToDate(dateStr:String)->Date
    {
        // Set date format
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd"
        // Get NSDate for the given string
        return dateFmt.date(from: dateStr)!
    }
    //Get the difference between two times
    func getCurrentDateComponents(toDate: Date)->Int
    {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.day] , from: Date() ,to: toDate )
        return dateComponents.day!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(SprialViewController.event)
        let x = LoginViewController.dbOjbect.triggerDatabase(method: "retriveCredentials/\(LoginViewController.uname!)")
        let guestCount = ((LoginViewController.dbOjbect.triggerDatabase(method: "guestCount/\(SprialViewController.eventId!)")[0]) as! NSDictionary)["count(*)"]! as! String
        let vendorCount = ((LoginViewController.dbOjbect.triggerDatabase(method: "vendorCount/\(SprialViewController.eventId!)")[0]) as! NSDictionary)["count(*)"]! as! String
        
        var y = (x[0] as! NSDictionary)["name"] as! String
        
        myDetailDatatSource[0].append(y)
        
        y = (x[0] as! NSDictionary)["username"] as! String
        myDetailDatatSource[0].append(y)
        
        y = (x[0] as! NSDictionary)["password"] as! String
        myDetailDatatSource[0].append(y)
        
        y = (x[0] as! NSDictionary)["email"] as! String
        myDetailDatatSource[0].append(y)
        
        myDetailDatatSource[1].append("\( SprialViewController.event!["name"]!)")
        myDetailDatatSource[1].append("\( SprialViewController.event!["budget"]!)")
        myDetailDatatSource[1].append("\( SprialViewController.event!["date"]!)")
        myDetailDatatSource[1].append("\( SprialViewController.event!["location"]!)")
        let date = getCurrentDateComponents(toDate: stngToDate(dateStr:myDetailDatatSource[1][2] as! String ))
        myDetailDatatSource[1].append("\(date)")
        myDetailDatatSource[1].append(guestCount)
        myDetailDatatSource[1].append(vendorCount)
        
   
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myDataSource[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueTableCell", for: indexPath)
        cell.textLabel?.text = myDataSource[indexPath.section][indexPath.row]
        
        cell.detailTextLabel?.textColor = UIColor.color(Int(arc4random_uniform(255)), green:  Int(arc4random_uniform(255)), blue: Int(arc4random_uniform(255)), alpha: 1.0)
        // Configure the cell...
        cell.imageView?.image = myImages[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = myDetailDatatSource[indexPath.section][indexPath.row] as! String
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
