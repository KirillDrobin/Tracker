//
//  TrackerStorage.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.10.2024.
//

import Foundation

final class TrackerStorage {
    static let shared = TrackerStorage()
    
    var daysOfWeekCellTextArray: [String] = []
    var date = [Date]()
    var trackerNameText = String()
    var currentTrackersIndexes = [Int]()
    
    var tracker = [Tracker]()
    
}
