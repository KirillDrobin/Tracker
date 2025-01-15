//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private let dateformatter = DateFormatter()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func trackerAndcategoryCreater(trackerCategoryName: String, tracker: Tracker) {
        
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
    
    func categoryNameFetch() -> String {
        let request = NSFetchRequest<TrackerCategoryCore>(entityName: "TrackerCategoryCore")
        let trackersCategoryFetch = try? context.fetch(request)
        let category = trackersCategoryFetch?.first?.categoryName
        
        return category ?? "Ошибка запроса названия категории"
    }
    
    private func dateArrayToStringConverter(array: [Date]) -> String {
        var dateStringArray = [String]()
        var dateString = String()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss +Z"
        for i in array {
            dateStringArray.append(dateformatter.string(from: i))
        }
        
        dateString = dateStringArray.joined(separator: ",")
        return dateString
    }
}
