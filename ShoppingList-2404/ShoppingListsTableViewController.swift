//
//  ShoppingListsTableViewController.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21. - 300872404
//  Copyright © 2017 Centennial College. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListsTableViewController: UITableViewController {
    
    let realm = try! Realm() // Load realm db
    
    // List of shopping lists
    var shoppingLists: List<ShoppingList> {
        get {
            return List(realm.objects(ShoppingList.self))
        }
        set {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ShoppingListTableViewCell // Load custom cell

        // Set cell values
        cell.listName.text = shoppingLists[indexPath.row].name

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { // Delete list
            (action, indexPath) in
            self.deleteList(at: indexPath.row)
        }
        return [deleteAction]
    }

    // Send selected list to next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case "listSegue":
            let destinationVC = segue.destination as! ListItemTableViewController
            if (tableView.indexPathForSelectedRow?.row != nil) {
                destinationVC.shoppingList = shoppingLists[(tableView.indexPathForSelectedRow?.row)!].items
                destinationVC.realm = realm
            }
            break
        default:
            break
        }
    }
    
    // Add new shopping list to the list
    func addList(_ shoppingList: ShoppingList) {
        try! self.realm.write {
            self.realm.add(shoppingList)
            tableView.insertRows(at: [IndexPath(row: shoppingLists.count - 1, section: 0)], with: .right)
        }
    }
    
    // Deleted shopping list
    func deleteList(at: Int) {
        try! self.realm.write {
            self.realm.delete(shoppingLists[at])
            tableView.deleteRows(at: [IndexPath(item: at, section: 0)], with: .automatic)
        }
    }
    
    // Show alert to create new shopping list with add button
    @IBAction func createList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new list", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            
            let listNameTF = alertController.textFields![0] as UITextField // List name text field
            
            let newList = ShoppingList()
            if listNameTF.text!.characters.count > 0 {
                newList.name = listNameTF.text!
                self.addList(newList)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name of list"
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
