//
//  ViewController.swift
//  Todoey
//
//  Created by Isaac Iniongun on 11/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath!)
        
        //loadItems()
    }
    
    //MARK: - Table View Datasource Methods
    
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
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //update item
        //itemArray[indexPath.row].setValue("new value for key", forKey: "'title' for instance")
        
        //delete an item
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //remove grey background from table view cell upon selection using an animation
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UiAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
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
    
    //MARK: - Model Manipulation Methods Here
    
    fileprivate func saveItems() {
        
        do{
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //reload tableView data
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error occurred fetching items: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Create a Predicate(WHERE CLAUSE) for fetching data
        //The [cd] makes the text case and diacritics(letters with accompanying special characters) insenstive. These means that CASE = case.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Add predicate to request
        request.predicate = predicate
        
        //Create a Descriptor(SORT) for organizing data
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Run on the main queue (the UI Thread)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
