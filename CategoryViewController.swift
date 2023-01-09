//
//  CategoryViewController.swift
//  Todoey-CoreData
//
//  Created by Sergio Ordaz Romero on 08/01/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var configCell = cell.defaultContentConfiguration()
        configCell.text = categories[indexPath.row].name
        cell.contentConfiguration = configCell
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    //MARK: -  Add New Categories
    @IBAction func addCategory(_ sender: Any) {
        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if !categoryTextField.text!.isEmpty {
                let category = Category(context: self.context)
                category.name = categoryTextField.text!
                self.categories.append(category)
                self.saveCategories()
            }
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category"
            categoryTextField = alertTextField
        }
        present(alert, animated: true)
    }
    
    //MARK: - Save Category
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Load Categories
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories =  try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error loading categories \(error)")
        }
    }
}
