//
//  ViewController.swift
//  Todoey
//
//  Created by Isaac Iniongun on 11/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import UIKit

class TodoListUserDefaultsAndNSCoderController: UITableViewController {
    
    var itemArray = [ItemModel]()
    
    //var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        //        for i: Int in 1...10{
        //            itemArray.append(Item(title: "Item \(i)"))
        //        }
        
        //grab the saved TodoListArray from userDefaults
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        loadItems()
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
        
        saveItems()
        
        //remove grey background from table view cell upon selection using an animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UiAlert
            self.itemArray.append(ItemModel(title: textField.text!))
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create new Item"
        }
        
        alert.addAction(action)
        
        //show the alert dialog
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods Here
    
    fileprivate func saveItems() {
        //save itemArray in user defaults
        //self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding data: \(error)")
        }
        
        //reload tableView data
        self.tableView.reloadData()
    }
    
    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([ItemModel].self, from: data)
//            } catch {
//                print("Error decoding Item Array: \(error)")
//            }
//        }
    }
    
}

