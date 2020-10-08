//
//	Realm reminders : Reminder.swift by Tymek on 06/10/2020 19:11.
//	Copyright ©Tymek 2020. All rights reserved.


import Foundation
import RealmSwift

class Reminder: Object{
    @objc dynamic var remName: String = ""
    @objc dynamic var remDate: Date?
    @objc dynamic var remCompletion: Bool = false
    @objc dynamic var remDueDate: Date?
    var toRemList = LinkingObjects(fromType: RemList.self, property: "toReminders")
}
