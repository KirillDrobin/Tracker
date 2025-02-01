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
    // MARK: - Public Properties
    var categoriesChange: Binding<Bool>? {
        didSet {
            categoriesChange?(vcInitStatus())
        }
    }
    
    var count: Binding<Int>? {
        didSet {
            count?(numberOfRowsInSection())
        }
    }
    
    var currentCategories: Binding<[String]>? {
        didSet {
            currentCategories?(currentCategoriesFetch())
        }
    }
        
    var selectedCategoryName = String()
    
    // MARK: - Private Properties
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var currentCategoriesStringArray = [String]()
    
    // MARK: - Init
    private init() { }
    
    // MARK: Private Methods
    private func vcInitStatus() -> Bool {
        if currentCategoriesStringArray.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func numberOfRowsInSection() -> Int {
        return currentCategoriesStringArray.count
    }
    
    // MARK: Public Methods
    func currentCategoriesFetch() -> [String] {
        var array = [String]()
        for i in trackerCategoryStore.fetchCategories() {
            array.append(i.categoryName)
        }
        currentCategoriesStringArray = array
        return array
    }
    
    func categoryNameSender(name: String) {
        selectedCategoryName = name
    }

    func saveCategory(trackerCategoryName: String) {
        trackerCategoryStore.categoryCreater(trackerCategoryName: trackerCategoryName)
    }
    
}
