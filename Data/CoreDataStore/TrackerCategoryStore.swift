//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    // MARK: - Properties
    static let shared = TrackerCategoryStore()
    
    private init() {}
    
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
    func trackerAndCategoryCreater(trackerCategoryName: String, tracker: Tracker) {
        let trackersCategory = TrackerCategoryCore(context: context)
        let trackers = TrackerCore(context: context)
       
        trackers.id = tracker.id
        trackers.trackerName = tracker.trackerName
        trackers.trackerColor = tracker.trackerColor
        trackers.trackerDate = dateArrayToStringConverter(array: tracker.trackerDate)
        trackers.trackerEmoji = tracker.trackerEmoji

        trackersCategory.categoryName = trackerCategoryName
        trackersCategory.addToTrackers(trackers)
                
        appDelegate.saveContext()
    }
    
    func categoryCreater(trackerCategoryName: String) {
        let trackersCategory = TrackerCategoryCore(context: context)
        trackersCategory.categoryName = trackerCategoryName
                
        appDelegate.saveContext()
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCore> = TrackerCategoryCore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        do {
            let categoryCoreDataArray = try context.fetch(fetchRequest)
            return categoryCoreDataArray.compactMap {
                TrackerCategory(
                    categoryName: $0.categoryName ?? "",
                    trackers: []
                )
            }
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    // MARK: - Private Methods
    private func dateArrayToStringConverter(array: [Date]) -> String {
        var dateStringArray = [String]()
        for i in array {
            dateStringArray.append(dateformatter.string(from: i))
        }
        return dateStringArray.joined(separator: ",")
    }
}
