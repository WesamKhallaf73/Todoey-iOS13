//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by wesam Khallaf on 5/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var CategoryArray : [Category] = []
    var textField = UITextField()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        loadCategory()
        

    }
    

    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category  ", message: "Enter the required Category to be added", preferredStyle: .alert)
               
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Enter the Category"
                   
                   self.textField = alertTextField
                   
               }
               
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                   // what will hapen when the user click add button in alert
                   
                   let newCategory : Category = Category(context: self.context)
                   newCategory.name = self.textField.text!
                   
                   self.CategoryArray.append(newCategory)
                   
                   // self.defaults.set(self.itemArray, forKey: "ToDoList")
                   self.saveCategory()
                   
                   DispatchQueue.main.async {
                       
                       self.tableView.reloadData()
                   }
                   
               }
               alert.addAction(action)
               present (alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
       
        do {
            try context.save()
            
        } catch {
            print ("error saving , \(error)")
            
        }
        
    }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = NSFetchRequest(entityName: "Category")
               do {
                   CategoryArray = try context.fetch(request)
                   
                       tableView.reloadData()
                   
               }
               catch {
                   print ("error feching data , \(error)")
               }
        
    }
    
}
// MARK: - TableView Extention
extension CategoryTableViewController {
    // MARK: - dataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = CategoryArray[indexPath.row].name
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewCOntroller = segue.destination as! TodoListTableViewController
        
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationViewCOntroller.selectedCategory = CategoryArray[indexpath.row]
        }
    }
}



