//
//  ViewController.swift
//  Todoey-CoreData
//
//  Created by Sergio Ordaz Romero on 07/01/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemsArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadItems()
    }
    
    //MARK: - Number of items of tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    //MARK: - Configuration of cell when that are createed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item =  itemsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var configCell = cell.defaultContentConfiguration()
        configCell.text = item.name
        cell.contentConfiguration = configCell
        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
    //MARK: - Functions triggered when selected a row of tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemsArray[indexPath.row].isChecked = !itemsArray[indexPath.row].isChecked
        saveItems()
    }
    
    //MARK: - Add new Item
    @IBAction func AddItem(_ sender: Any) {
        var newItemTextField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if !newItemTextField.text!.isEmpty {
                let item = Item(context: self.context)
                item.name = newItemTextField.text!
                self.itemsArray.append(item)
                self.saveItems()
            }
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "New Item"
            newItemTextField = alertTextField
        }
        present(alert, animated: true)
    }
    
    //MARK: - Save Items
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Read Items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemsArray = try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error) ")
        }
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    //MARK: - Search Items
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!.lowercased())
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadItems(with: request)
    }
}

