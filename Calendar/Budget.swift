//
//  Budget.swift
//  Budget
//
//  Created by Zato on 11/13/16.
//  Copyright © 2016 Yellow Team. All rights reserved.
//

import UIKit


struct Budget {
    var id: Int = SprialViewController.eventId!
    var amount: Float = 0.00
    var spent: Float = 0.00 {
        didSet {
            self.remaining = self.amount - self.spent
        }
    }
    var remaining: Float
    
    
    init(_ amt: Float) {
        self.amount = amt
        self.remaining = amt
    }
}




struct Category {
    var id: Int = SprialViewController.eventId!
    var budget: Float = 0.00
    var name: String
    
    init(_ name: String, _ amt: Float) {
        self.name = name
        self.budget = amt
    }
}




struct Item {
    var id: Int = SprialViewController.eventId!
    var category_name = ""
    var item_name: String
    var cost: Float
    var deposit: Float
    var balance_due: Float
    var balance_due_date: String
    var paid_by: String
    
    
    init(_ name: String) {
        self.item_name = name
        self.cost = 0.00
        self.deposit = 0.00
        self.balance_due = self.cost - self.deposit
        self.balance_due_date = ""
        self.paid_by = ""
    }
}




























