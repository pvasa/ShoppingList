//
//  ShoppingList.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21.
//  Copyright © 2017 Centennial College. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingList: Object {
    
    dynamic var name: String = "List name"
    var items: List<ListItem> = List()
    dynamic var itemsCount: Int {
        get {
            return items.count
        }
    }
    
}

class ListItem: Object {
    
    dynamic var name: String = "Item name"
    dynamic var qty: Int = 0
    
}
