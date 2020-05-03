//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by wesam Khallaf on 5/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
   
    let realm = try! Realm()
    var categories : Results<Category>?
    var textField = UITextField()
    //var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   
     
        
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        loadCategory()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Todoey"

    }
    

    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category  ", message: "Enter the required Category to be added", preferredStyle: .alert)
               
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Enter the Category"
                   
                   self.textField = alertTextField
                   
               }
               
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                   // what will hapen when the user click add button in alert
                   
                   let newCategory : Category = Category()
                   newCategory.name = self.textField.text!
                   
                   //self.categories.append(newCategory)
                   
                   
                   self.save(newCategory)
                   
                   DispatchQueue.main.async {
                       
                       self.tableView.reloadData()
                   }
                   
               }
               alert.addAction(action)
               present (alert, animated: true, completion: nil)
    }
    
    func save(_ category : Category ) {
       
        do {
            try realm.write{
                realm.add(category)
            }
            
        } catch {
            print ("error saving , \(error)")
            
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
         categories = realm.objects(Category.self)
        
        
            tableView.reloadData()
       
        
    }
    
}
// MARK: - TableView Extention
extension CategoryTableViewController {
    // MARK: - dataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories == nil ? 0 :  categories!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        cell?.textLabel?.text = categories?[indexPath.row].name
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewCOntroller = segue.destination as! TodoListTableViewController
        
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationViewCOntroller.selectedCategory = categories![indexpath.row]
            self.navigationItem.title = categories![indexpath.row].name
        }
    }
}



