//
//  TrackerCategoryFixStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.02.2025.
//

import CoreData
import UIKit

final class TrackerCategoryFixStore: NSObject {
    // MARK: - Properties
    static let shared = TrackerCategoryFixStore()
    
    private override init() {}
    
    private let trackerStore = TrackerStore.shared
    
    private let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +Z"
        return formatter
    }()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    
    // MARK: - Methods
    func trackerAndCategoryFixCreater(trackerCategoryName: String, tracker: Tracker) {
        let trackerCategoryFix = fetchOrCreateNewCategoryFix(categoryName: trackerCategoryName)
        let trackersFix = TrackerFixCore(context: context)
        
        trackersFix.idFix = tracker.id
        trackersFix.trackerNameFix = tracker.trackerName
        trackersFix.trackerColorFix = tracker.trackerColor
        trackersFix.trackerDateFix = dateArrayToStringConverter(array: tracker.trackerDate)
        trackersFix.trackerEmojiFix = tracker.trackerEmoji
        trackersFix.categoryFix = trackerCategoryFix
        
        appDelegate.saveContext()
    }
    
    
    
    
    func fetchCurrentTrackerCategoryFixData() {
        let request = NSFetchRequest<TrackerCategoryFixCore>(entityName: "TrackerCategoryFixCore")
                
        guard let trackers = try? context.fetch(request) else { return }
    }
    
    
    
    
    
    
    // MARK: - Private Methods
    private func dateArrayToStringConverter(array: [Date]) -> String {
        var dateStringArray = [String]()
        for i in array {
            dateStringArray.append(dateformatter.string(from: i))
        }
        return dateStringArray.joined(separator: ",")
    }
    
    private func stringToDateArrayConverter(string: String) -> [Date] {
        var dateStringArray = [String]()
        var dateArray = [Date]()
        dateStringArray = string.components(separatedBy: ",")
        for i in dateStringArray {
            dateArray.append(dateformatter.date(from: i) ?? Date())
        }
        return dateArray
    }
    
    private func fetchOrCreateNewCategoryFix(categoryName: String) -> TrackerCategoryFixCore {
        if let existingCategory = fetchCategoryFix(categoryName: categoryName) {
            return existingCategory
        }
        let newCategory = TrackerCategoryFixCore(context: context)
        newCategory.categoryNameFix = categoryName
        appDelegate.saveContext()
        
        return newCategory
    }
    
    
    private func fetchCategoryFix(categoryName: String) -> TrackerCategoryFixCore? {
        let fetchRequest: NSFetchRequest<TrackerCategoryFixCore> = TrackerCategoryFixCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryNameFix == %@", categoryName)
        let categories = try? context.fetch(fetchRequest)
        return categories?.first
    }
}
