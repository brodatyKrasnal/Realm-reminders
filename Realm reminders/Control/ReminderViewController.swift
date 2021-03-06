//
//	Realm reminders : ViewController.swift by Tymek on 06/10/2020 19:06.
//	Copyright ©Tymek 2020. All rights reserved.

import UIKit
import RealmSwift

class ReminderViewController: GenericTableViewController {
    
    var reminders: Results<Reminder>?
    
    var passedRemList: RemList? {
        didSet {
            readRealm()
            title = passedRemList!.listName
            print(passedRemList!.listName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let backColor = UIColor(hexString: passedRemList!.listColor) {
            view.backgroundColor = backColor
            navigationController?.navigationBar.backgroundColor = backColor
        }
    }
    
    //MARK: - TableView Data Management
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let reminder = reminders?[indexPath.row] {
            cell.textLabel?.text = reminder.remName
            cell.accessoryType = reminder.remCompletion == true ? .checkmark : .none
            if let color = passedRemList?.listColor {
                let index = indexPath.row
                cell.backgroundColor = UIColor(hexString: color)!.darken(byPercentage: (CGFloat(index) / CGFloat(reminders!.count) / 2))
                cell.textLabel?.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: color)!, isFlat: true)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reminder = reminders?[indexPath.row] {
            do {
                try realm.write {
                    reminder.remCompletion = !reminder.remCompletion
                }
            } catch {
                print("Error while changing done property for: \(reminder.remName): \(error) ")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Realm Data Management
    func save (this elemenet: Reminder?) {
        
        if let newElement = elemenet {
            do {
                try realm.write {
                    realm.add(newElement)
                }
            } catch {
                print("Error while saving \(error)")
            }
            tableView.reloadData()
        }
    }
    
    func readRealm () {
        reminders = passedRemList?.toReminders.sorted(byKeyPath: "remName",ascending: true)
        tableView.reloadData()
    }
    
    override func removeElement(this element: IndexPath) {
        if let pickedItem = reminders?[element.row] {
            do {
                try realm.write {
                    self.realm.delete(pickedItem)
                }
            } catch {
                print("Errror while remiving item: \(pickedItem) : \(error)")
            }
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Adding New Reminders
    
    @IBAction func addNewReminder(_ sender: UIBarButtonItem) {
        var userText = UITextField()
        
        let alert = UIAlertController(title: "Add new reminder", message: "", preferredStyle: .alert)
        
        alert.addTextField { (inputText) in
            userText = inputText
            inputText.placeholder = "Add new note here"
            inputText.textAlignment = .center
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let passedCat = self.passedRemList {
                do {
                    try self.realm.write {
                        let item = Reminder()
                        item.remDate = Date()
                        item.remName = userText.text!
                        item.remCompletion = false
                        passedCat.toReminders.append(item)
                        self.readRealm()
                    }
                } catch {
                    print("Error while saving reminder: \(error)")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - SearchBar Methods
extension ReminderViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reminders = reminders?.filter(NSPredicate(format: "remName CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "remName", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            readRealm()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

