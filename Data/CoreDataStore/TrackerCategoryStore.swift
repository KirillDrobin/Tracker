//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    // MARK: - Properties
    static let shared = TrackerCategoryStore()
    
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCore> = {
        
        let fetchRequest = TrackerCategoryCore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tracker", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    // MARK: - Methods
    func trackerAndCategoryCreater(trackerCategoryName: String, tracker: Tracker) {
        let trackerCategory = fetchOrCreateNewCategory(categoryName: trackerCategoryName)
        let trackers = TrackerCore(context: context)
        
        trackers.id = tracker.id
        trackers.trackerName = tracker.trackerName
        trackers.trackerColor = tracker.trackerColor
        trackers.trackerDate = dateArrayToStringConverter(array: tracker.trackerDate)
        trackers.trackerEmoji = tracker.trackerEmoji
        trackers.category = trackerCategory
        
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
    
    func fetchCurrentTrackerCategoryData(calendar: Calendar, sender: Date) -> [TrackerCategory] {
        let request = NSFetchRequest<TrackerCategoryCore>(entityName: "TrackerCategoryCore")
                
        guard let trackers = try? context.fetch(request) else { return [] }
        
        var data = [TrackerCategory]()
        for i in trackers {
            guard let arr = i.trackers?.allObjects as? [TrackerCore] else { return [] }
            var trackersArr = [Tracker]()
            for item in arr {
                for id in trackerStore.fetchCurrentId(calendar: calendar, sender: sender) {
                    if id == item.id {
                        trackersArr.append(Tracker(id: item.id,
                                                   trackerName: item.trackerName ?? "error tracker name",
                                                   trackerColor: item.trackerColor,
                                                   trackerEmoji: item.trackerEmoji ?? "",
                                                   trackerDate: stringToDateArrayConverter(string: item.trackerDate ?? "date error") ))
                        
                        
                    }
                    
                }
            }
            if !trackersArr.isEmpty {
                data.append(TrackerCategory(categoryName: i.categoryName ?? "", trackers: trackersArr))
            }
        }
        
        return data
    }
    
//    func updateTracker(id: Int64) {
//        let fetchRequest = NSFetchRequest<TrackerCategoryCore>(entityName: "TrackerCategoryCore")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
//        guard let trackers = try? context.fetch(fetchRequest) as? [TrackerCategory] else { return }
//        guard let tracker = trackers.first(where: {$0.trackers.first(where: {$0.id == id})}) else { return }
//        tracker.trackers[0].id =
//        
//    }
    
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
    
    private func fetchOrCreateNewCategory(categoryName: String) -> TrackerCategoryCore {
        if let existingCategory = fetchCategory(categoryName: categoryName) {
            return existingCategory
        }
        let newCategory = TrackerCategoryCore(context: context)
        newCategory.categoryName = categoryName
        appDelegate.saveContext()
        
        return newCategory
    }
    
    private func fetchCategory(categoryName: String) -> TrackerCategoryCore? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCore> = TrackerCategoryCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        let categories = try? context.fetch(fetchRequest)
        return categories?.first
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(name: NotificationNames.coreDataChange, object: nil)
    }
}
