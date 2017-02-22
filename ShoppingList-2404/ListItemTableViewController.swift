//
//  ListItemTableViewController.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21.
//  Copyright © 2017 Centennial College. All rights reserved.
//

import UIKit
import RealmSwift

class ListItemTableViewController: UITableViewController {
    
    var shoppingList: List<ListItem>!
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingList != nil ? shoppingList!.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListItemTableViewCell

        cell.itemName.text = shoppingList[indexPath.row].name
        cell.quantity.text = String(shoppingList[indexPath.row].qty)
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (action, indexPath) in
            self.deleteItem(at: indexPath.row)
        }
        return [deleteAction]
    }
    
    func addItem(_ item: ListItem) {
        try! self.realm.write {
            shoppingList.append(item)
            tableView.insertRows(at: [IndexPath(row: shoppingList.count - 1, section: 0)], with: .right)
        }
    }
    
    func deleteItem(at: Int) {
        try! self.realm.write {
            shoppingList.remove(objectAtIndex: at)
            tableView.deleteRows(at: [IndexPath(item: at, section: 0)], with: .automatic)
        }
    }
    
    @IBAction func addListItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new list", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            
            let itemNameTF = alertController.textFields![0] as UITextField
            let itemQtyTF = alertController.textFields![1] as UITextField
            
            let newListItem = ListItem()
            if itemNameTF.text!.characters.count > 0 && itemQtyTF.text!.characters.count > 0 {
                newListItem.name = itemNameTF.text!
                newListItem.qty = Int(itemQtyTF.text!)!
                self.addItem(newListItem)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name of item"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = .numberPad
            textField.placeholder = "Item quantity"
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
