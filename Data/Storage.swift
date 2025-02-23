//
//  RootViewControllerStatus.swift
//  Tracker
//
//  Created by Кирилл Дробин on 22.01.2025.
//

import Foundation

final class Storage {
    
    static let shared = Storage()
    
    private init() { }
    
    private let storage: UserDefaults = .standard
    
    var status: Bool {
        get {
            let status = storage.bool(forKey: Keys.status.rawValue)
            return status
        }
        set {
            storage.set(newValue, forKey: Keys.status.rawValue)
        }
    }
    
    var trackerViewStatus: Int {
        get {
            let status = storage.integer(forKey: Keys.trackerViewStatus.rawValue)
            return status
        }
        set {
            storage.set(newValue, forKey: Keys.trackerViewStatus.rawValue)
        }
    }
    
    var trackerCategoryNameArray: [String] {
        get {
            guard let name = storage.stringArray(forKey: Keys.categoryNameArray.rawValue) else { return [] }
            return name
        }
        set {
            storage.set(newValue, forKey: Keys.categoryNameArray.rawValue)
        }
    }
    
    var filteredTrackersData: [Tracker] {
        get {
            guard let trackers = storage.array(forKey: Keys.filteredTrackers.rawValue) else { return [] }
            return trackers as? [Tracker] ?? []
        }
        set {
            storage.set(newValue as [Tracker], forKey: Keys.filteredTrackers.rawValue)
        }
    }
    
    var filterViewControllerIndex: Int {
        get {
            let index = storage.integer(forKey: Keys.filterViewControllerIndex.rawValue)
            return index
        }
        set {
            storage.set(newValue, forKey: Keys.filterViewControllerIndex.rawValue)
        }
    }
    
    private enum Keys: String {
        case status
        case categoryNameArray
        case filteredTrackers
        case filterViewControllerIndex
        case trackerViewStatus
    }
}
