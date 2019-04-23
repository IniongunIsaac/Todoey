//
//  ViewController.swift
//  Todoey
//
//  Created by Isaac Iniongun on 11/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<ItemData>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : CategoryData? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //set the title of the view
        title = selectedCategory!.name
        
        //set the background of the status bar to the color of the selected category
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        updateNavBar(withHexColor: colorHex)
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexColor: "ID9BF6")
        
    }
    
    //MARK: - NavBar Setup methods
    
    func updateNavBar(withHexColor colorHex: String) {
        
        guard let categoryColor = UIColor(hexString: colorHex) else { fatalError() }
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        
        //change the background color of the navigation bar
        navBar.barTintColor = categoryColor
        
        //change the color of the navbar icons
        navBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        //change the forground color of the navbar title
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(categoryColor, returnFlat: true)]
        
        //set the background of the search bar
        searchBar.barTintColor = categoryColor
    }
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //toggle checkmark accessory to the right end of the selected row upon selection and de-selection
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added."
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                    item.dateUpdated = NSDate()
                }
            } catch {
                print("Error saving item: \(error)")
            }
        }
        
        tableView.reloadData()
        
        //remove grey background from table view cell upon selection using an animation
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item button on our UiAlert
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try self.realm.write {
                        let newItem = ItemData()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
            }
            
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
    
    //MARK: - Model Manipulation Methods Here
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                realm.delete((todoItems?[indexPath.row])!)
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
}

//MARK: - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
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
