//
//	Realm reminders : RemList.swift by Tymek on 07/10/2020 14:48.
//	Copyright ©Tymek 2020. All rights reserved.

import Foundation
import RealmSwift

class RemList: Object {
    @objc dynamic var listName:String = ""
    @objc dynamic var listDate: Date?
    @objc dynamic var listColor: String = ""
    var toReminders = List<Reminder>()
}
