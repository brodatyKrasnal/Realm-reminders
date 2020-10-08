//
//	Realm reminders : RemListTableVC.swift by Tymek on 07/10/2020 15:38.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import RealmSwift

class RemListTableVC: GenericTableViewController {
    
    var lists: Results<RemList>?
    
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
        if let result = lists?[indexPath.row]{
            cell.textLabel?.text = result.listName
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
        popup.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alert) in
            let newList = RemList()
            newList.listName = capturedText.text!
            newList.listDate = Date()
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


    
}
