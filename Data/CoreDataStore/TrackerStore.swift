//
//  TrackerStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    static let shared = TrackerStore()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func createTracker(id: Int64,
                       trackerName: String,
                       trackerColor: Int16,
                       trackerEmoji: String,
                       trackerDate: [Date])
    {
        guard let trackerentityDescription = NSEntityDescription.entity(forEntityName: "TrackerCore", in: context) else { return }
        let trackerStore = TrackerCore(entity: trackerentityDescription, insertInto: context)
        trackerStore.id = id
        trackerStore.trackerName = trackerName
        trackerStore.trackerColor = trackerColor
        trackerStore.trackerDate = arrayToStringConverter(array: trackerDate)
        trackerStore.trackerEmoji = trackerEmoji
        
        appDelegate.saveContext()
        print("\(trackerStore)")
    }
    
    func arrayToStringConverter(array: [Date]) -> String {
        var dateStringArray = [String]()
        var dateString = String()
        for i in array {
            dateStringArray.append("\(i)")
        }
        dateString = dateStringArray.joined(separator: ",")
        print("date string: \(dateString)")
        return dateString
    }
    
//    func fetchTrackers() -> [TrackerCoreData] {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCoreData")
//        do {
//            return (try? context.fetch(fetchRequest) as? [TrackerCoreData]) ?? []
//        }
//    }
    
}
