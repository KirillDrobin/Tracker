//
//  CategoryMainViewModel.swift
//  Tracker
//
//  Created by Кирилл Дробин on 23.01.2025.
//

import Foundation

final class CategoryMainViewModel {
    // MARK: - Singletone
    static var shared = CategoryMainViewModel()
    
    var categoriesChange: Binding<[String]>?
    var currentCategoryName = String()
    var cellCount = Int()
    
    private let storage = Storage.shared
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    private(set) var trackerCategoryNameArray: [String] = [] {
        didSet {
            categoriesChange?(trackerCategoryNameArray)
        }
    }
    
    private init() {
        currentCategoryNameMethod()
        print("ViewModelInit")
        print("массив имен категорий \(trackerCategoryNameArray)")
        
    }
    
    // MARK: Public Methods
    func numberOfRowsInSection() -> Int {
        return storage.trackerCategoryNameArray.count
    }
    
    func cellTextLabelFetch() -> [String] {
        var array = [String]()
        for i in trackerCategoryStore.fetchCategories() {
            array.append(i.categoryName)
        }
        return array
    }
    
    func vcInitStatus() -> Bool {
        if storage.trackerCategoryNameArray == [] {
            return true
        } else {
            return false
        }
        print("status \(vcInitStatus())")
    }
    
    func categoryTableViewHeightUpdate() -> Bool {
        if storage.trackerCategoryNameArray.count == 7 {
            true
        } else {
            false
        }
    }
    
    func trackerCategoryNameArraySet(sender: String) {
        trackerCategoryNameArray.append(sender)
    }
    
    func categoryNameSender(name: String) {
        currentCategoryName = name
        NotificationCenter.default.post(name: NotificationNames.coreDataChange, object: nil)
    }
    
    private func currentCategoryNameMethod() {
        var stringArray = [String]()
        for i in trackerCategoryStore.fetchCategories() {
            stringArray.append(i.categoryName)
        }
        storage.trackerCategoryNameArray = stringArray
        print("массив имен категорий \(trackerCategoryNameArray)")
    }
}

