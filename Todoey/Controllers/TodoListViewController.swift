//
//  ViewController.swift
//  Todoey
//
//  Created by Isaac Iniongun on 11/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i: Int in 1...10{
            itemArray.append(Item(title: "Item \(i)"))
        }
        
        //grab the saved TodoListArray from userDefaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as UITableViewCell
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //toggle checkmark accessory to the right end of the selected row upon selection and de-selection
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //remove grey background from table view cell upon selection using an animation
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UiAlert
            self.itemArray.append(Item(title: textField.text!))
            
            //save itemArray in user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //reload tableView data
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new Item"
        }
        
        alert.addAction(action)
        
        //show the alert dialog
        present(alert, animated: true, completion: nil)
        
    }
    
}

