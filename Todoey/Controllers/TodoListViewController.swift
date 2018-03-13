//
//  TodoListViewController.swift
//  Todoey
//
//  Created by David on 3/4/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        saveItems()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        

        tableView.deselectRow(at: indexPath, animated: true)

        
    }
    
  
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            //what will happen once the user clicks the add item button in our UI Alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
         //   let data = encoder.encode(itemArray)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
    
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("lots of errors\(error)")
            }
        }
    }
    
}
//MarkAdd new items seciont.


