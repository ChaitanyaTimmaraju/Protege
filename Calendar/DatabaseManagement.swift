//
//  DatabaseManagement.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 11/4/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import Foundation

class DatabaseManagement {
    let baseString:String = "https://cs.okstate.edu/~saivams/Protege/cs4143Connection.php"
    var json:NSMutableArray? = []
    var check = false
    
    func triggerDatabase(method:String)->NSMutableArray{
        check = false
        let triggerString = baseString + "/" + method
        print("\n\n\n\n\n"+triggerString)
        let url = URL(string: triggerString)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url!) {(data,response,error) in
            guard error == nil else{
                print("Error in session call:\(error)")
                return
            }
            guard let result = data else{
                print("No data recieved")
                return
            }
            do{
                        let returnArray = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as? NSArray
                        self.json =  NSMutableArray(array: returnArray!)
                        self.check = true
            }catch {
                print("Error Serialization JSON Data\n\n\n\n\n\n\n\n\n")
                self.check = true
            }
        }
          task.resume()
        while !check { }
          return json!
        
       
    }
}
