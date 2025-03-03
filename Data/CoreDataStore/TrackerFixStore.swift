//
//  TrackerFixStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.02.2025.
//

import UIKit
import CoreData

final class TrackerFixStore: NSObject {
    // MARK: - Singletone
    static let shared = TrackerFixStore()
    
    // MARK: - Private properties
    private override init() {}
    
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
        func fetchCurrentTrackersData(currentTrackersIndexes: [Int]) -> [Tracker] {
            let request = NSFetchRequest<TrackerCore>(entityName: "TrackerCore")
            
            guard let trackers = try? context.fetch(request) else { return [] }
            
            var currentTrackerDataArray = [Tracker]()
            for i in currentTrackersIndexes {
                currentTrackerDataArray.append(
                    .init(
                        id: trackers[i].id,
                        trackerName: trackers[i].trackerName ?? "",
                        trackerColor: trackers[i].trackerColor,
                        trackerEmoji: trackers[i].trackerEmoji ?? "",
                        trackerDate: stringToDateArrayConverter(string: trackers[i].trackerDate ?? "")
                    )
                )
            }
            return currentTrackerDataArray
        }
    
    func fetchSelectedFixTracker(trackerId: Int64) -> [TrackerCategory] {
        var selectedTracker = [TrackerCategory]()
        let fetchRequest = NSFetchRequest<TrackerFixCore>(entityName: "TrackerFixCore")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "idFix == \(trackerId)")
        guard let tracker = try? context.fetch(fetchRequest) else { return [] }
        
        selectedTracker.append(TrackerCategory(categoryName: tracker.first?.categoryFix?.categoryNameFix ?? "",
                                               trackers: [Tracker(id: tracker[0].idFix,
                                                                  trackerName: tracker[0].trackerNameFix ?? "",
                                                                  trackerColor: tracker[0].trackerColorFix,
                                                                  trackerEmoji: tracker[0].trackerEmojiFix ?? "",
                                                                  trackerDate: stringToDateArrayConverter(string: tracker[0].trackerDateFix ?? ""))]))
        return selectedTracker
    }
    
    func deleteSelectedFixTracker(trackerId: Int64) {
        let fetchRequest = NSFetchRequest<TrackerFixCore>(entityName: "TrackerFixCore")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "idFix == \(trackerId)")
        let tracker = try? context.fetch(fetchRequest)
        guard let deleteTracker = tracker?.first(where: {$0.idFix == trackerId}) else { return }
        context.delete(deleteTracker)
        appDelegate.saveContext()
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
}
