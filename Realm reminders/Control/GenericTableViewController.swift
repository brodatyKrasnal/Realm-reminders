//
//	Realm reminders : GenericTableViewController.swift by Tymek on 06/10/2020 19:16.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class GenericTableViewController: UITableViewController, SwipeTableViewCellDelegate  {
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.removeElement(this: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func removeElement (this element: IndexPath) {
        //
    }
    

    

    
}
