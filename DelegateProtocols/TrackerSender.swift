//
//  TrackerSender.swift
//  Tracker
//
//  Created by Кирилл Дробин on 25.12.2024.
//

import UIKit

protocol TrackerSender: AnyObject {
    func trackerSender(trackerData: Tracker)
    func categoryChecker(id: UInt, trackerCategoryName: String, trackerNameText: String, date: [Date], color: UIColor, emoji: String)
}
