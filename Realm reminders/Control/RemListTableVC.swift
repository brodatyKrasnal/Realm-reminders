//
//	Realm reminders : RemListTableVC.swift by Tymek on 07/10/2020 15:38.
//	Copyright ©Tymek 2020. All rights reserved.

import UIKit
import RealmSwift
import ChameleonFramework

class RemListTableVC: GenericTableViewController {
    
    var lists: Results<RemList>?
    
    let colors = ["ffadad","ffd6a5","fdffb6","caffbf","9bf6ff","a0c4ff","bdb2ff","ffc6ff","fffffc","a7bed3","c6e2e9","f1ffc4","ffcaaf","dab894"]
    
    var maxIndex: Int {
        if let lista = lists?.count {
            return lista % colors.count
        } else {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readRealm()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let result = lists?[indexPath.row] {
            cell.textLabel?.text = result.listName
            cell.backgroundColor = UIColor(hexString: result.listColor)
            tableView.backgroundColor = UIColor(hexString: colors[maxIndex])
            navigationController?.navigationBar.backgroundColor = UIColor(hexString: colors[maxIndex])
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toReminders", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ReminderViewController
        if let pickedIndex = tableView.indexPathForSelectedRow {
            destVC.passedRemList = lists?[pickedIndex.row]
        }
    }
    
    //MARK: - Add New RemList
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var capturedText = UITextField()
        
        let popup = UIAlertController(title: "Add new list.", message: "", preferredStyle: .alert)
        
        popup.addTextField { (textField) in
            capturedText = textField
            textField.placeholder = "Provide your list name."
            textField.textAlignment = .center
        }
        
        popup.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        popup.addAction(UIAlertAction(title: "Add", style: .default, handler: {(alert) in
            let newList = RemList()
            let itemIndex = (self.lists?.count ?? 0 + 1) % self.colors.count
            newList.listName = capturedText.text!
            newList.listDate = Date()
            newList.listColor = self.colors[itemIndex]
            self.save(this: newList)
        }))
        present(popup, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func save (this elemenet: RemList?) {
        
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
        lists = realm.objects(RemList.self).sorted(byKeyPath: "listDate", ascending: true)
        tableView.reloadData()
    }
    
    override func removeElement(this element: IndexPath) {
        if let pickedItem = lists?[element.row] {
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
    
    
}
