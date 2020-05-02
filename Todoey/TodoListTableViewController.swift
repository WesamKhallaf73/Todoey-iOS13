//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController  , UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
   
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    var textField = UITextField()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray :[Item] = []
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // var defaults = UserDefaults.standard
    
    
    // MARK: - action for textfield
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "Enter the required action", preferredStyle: .alert)
        
        alert.addTextField { (aletTextField) in
            aletTextField.placeholder = "Enter the new Item"
            
            self.textField = aletTextField
            
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hapen when the user click add button in alert
            
            let newItem : Item = Item(context: self.context)
            newItem.title = self.textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // self.defaults.set(self.itemArray, forKey: "ToDoList")
            self.saveItem()
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(action)
        present (alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
   
        
    }
    // MARK: - encoding and decoding data
    func saveItem() {
        
        
        
        do {
            try context.save()
            print("item saved ")
            
        } catch {
            print ("error saving , \(error)")
            
        }
        
    }
    
    func loadItem (){
        
       
        
        let request : NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
      // let predicat = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       let  predicat = NSPredicate(format: "parentCategory == %@", selectedCategory!)
        
        request.sortDescriptors = []
        request.predicate = predicat
      
        do {
            itemArray = try context.fetch(request)
            
                tableView.reloadData()
            
        }
        catch {
            print ("error feching data , \(error)")
        }
       
    }
    
    // MARK: - searchbar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    // it can be written as
       // let request : NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        print ("search button clicked")
       let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicat = NSPredicate(format: "title CONTAINS[cd] %@ AND parentCategory.name == %@ ", searchBar.text! , selectedCategory!.name! )
        ////@"age == 40 AND price > 67"
        request.predicate = predicat
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors?.append(sortDescriptor)
        do {
            itemArray = try context.fetch(request)
            
                tableView.reloadData()
            
        }
        catch {
            print ("error feching data , \(error)")
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
            
            
        }
    }
    
    /*
    *
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
 */
    // MARK: - table view delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")
        cell?.textLabel?.text = itemArray[indexPath.row].title
        
        cell?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveItem()
            tableView.reloadData()
        }
       
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}


