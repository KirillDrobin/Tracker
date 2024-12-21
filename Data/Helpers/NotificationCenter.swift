//
//  NotificationCenter.swift
//  Tracker
//
//  Created by Кирилл Дробин on 14.12.2024.
//

import Foundation

extension Notification.Name {
    static let valueChange = Notification.Name("value change")
    static let recordPlus = Notification.Name("record plus")
    static let recordMinus = Notification.Name("record minus")
}
