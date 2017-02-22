//
//  ShoppingList.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21. - 300872404
//  Copyright © 2017 Centennial College. All rights reserved.
//

import Foundation
import RealmSwift

// Shopping list class
class ShoppingList: Object {
    
    dynamic var name: String = "List name" // Name of the list
    var items: List<ListItem> = List() // Items in the list
    dynamic var itemsCount: Int { // Count of items in the list
        get {
            return items.count
        }
    }
    
}

// Item class
class ListItem: Object {
    
    dynamic var name: String = "Item name" // Item name
    dynamic var qty: Int = 0 // Item quantity
    
}
