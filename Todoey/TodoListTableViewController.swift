//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListTableViewController: UITableViewController  , UISearchBarDelegate
{
    
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
   
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    var textField = UITextField()
    
    
    var items :Results<Item>?
   
    
    // MARK: - action for textfield
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "Enter the required action", preferredStyle: .alert)
        
        alert.addTextField { (aletTextField) in
            aletTextField.placeholder = "Enter the new Item"
            
            self.textField = aletTextField
            
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will hapen when the user click add button in alert
            if self.selectedCategory != nil {
                
                do {
                    try self.realm.write{
                        
                        let newItem : Item = Item()
                        newItem.title = self.textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        self.selectedCategory?.items.append(newItem)
                    } }
                catch {
                    print ("error saving , \(error)")
                }
                
                
                
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
    
    
    func loadItem (){
        
       
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
       
    }
    
    // MARK: - searchbar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        items = items?.filter("title CONTAINS [cd] %d", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
            
            
        }
    }
    
    
    // MARK: - table view delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ??  0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell")
        cell?.textLabel?.text = items?[indexPath.row].title
        
        cell?.accessoryType = items![indexPath.row].done ? .checkmark : .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
            try self.realm.write{
            realm.delete(items![indexPath.row])
            //itemArray.remove(at: indexPath.row)
                }}
                catch {
                    print (" error deleting  , \(error)")
                }
           loadItem()
            tableView.reloadData()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items?[indexPath.row] != nil {
        do {
            try self.realm.write{
                self.items![indexPath.row].done = !self.items![indexPath.row].done
            }
        }
        catch {
            print (" error updating ,\(error)")
        }
        }
         tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
    
    
    
}


