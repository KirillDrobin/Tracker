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
    
    var trackerCategoryNameArray: [String] {
        get {
            guard let name = storage.stringArray(forKey: Keys.categoryNameArray.rawValue) else { return [] }
            return name
        }
        set {
            storage.set(newValue, forKey: Keys.categoryNameArray.rawValue)
        }
    }
    
    private enum Keys: String {
        case status
        case categoryNameArray
    }
}
