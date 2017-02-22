//
//  ShoppingListsTableViewController.swift
//  ShoppingList-2404
//
//  Created by Ryan on 2017-02-21.
//  Copyright © 2017 Centennial College. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListsTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shoppingLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ShoppingListTableViewCell

        cell.listName.text = shoppingLists[indexPath.row].name

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
            self.deleteList(at: indexPath.row)
        }
        return [deleteAction]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case "listSegue":
            let destinationVC = segue.destination as! ListItemTableViewController
            //destinationVC.delegate = self
            if (tableView.indexPathForSelectedRow?.row != nil) {
                destinationVC.shoppingList = shoppingLists[(tableView.indexPathForSelectedRow?.row)!].items
                destinationVC.realm = realm
            }
            break
        default:
            break
        }
    }
    
    func addList(_ shoppingList: ShoppingList) {
        try! self.realm.write {
            self.realm.add(shoppingList)
            tableView.insertRows(at: [IndexPath(row: shoppingLists.count - 1, section: 0)], with: .right)
        }
    }
    
    func deleteList(at: Int) {
        try! self.realm.write {
            self.realm.delete(shoppingLists[at])
            tableView.deleteRows(at: [IndexPath(item: at, section: 0)], with: .automatic)
        }
    }
    
    @IBAction func createList(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new list", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            alert -> Void in
            
            let listNameTF = alertController.textFields![0] as UITextField
            
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
