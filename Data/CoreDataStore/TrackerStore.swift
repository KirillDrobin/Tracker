//
//  TrackerStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    // MARK: - Singletone
    static let shared = TrackerStore()
    
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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCore> = {

        let fetchRequest = TrackerCore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()

        return fetchedResultsController
    }()
    
    // MARK: - Methods
    func fetchCurrentIndexes(calendar: Calendar, sender: Date) -> [Int] {
        var currentTrackersIndexes = [Int]()
        guard let trackers = fetchedResultsController.fetchedObjects else { return [] }
        
        for (index, item) in trackers.enumerated() {
            let dateArray = stringToDateArrayConverter(string: item.trackerDate ?? "trackers date error")
            
            for i in dateArray {
                var cellDatecomponents = DateComponents()
                var senderDatecomponets = DateComponents()
                
                senderDatecomponets.weekday = calendar.dateComponents([.weekday], from: sender).weekday
                cellDatecomponents.weekday = calendar.dateComponents([.weekday], from: i).weekday
                if cellDatecomponents == senderDatecomponets && item.id <= 10000 {
                    currentTrackersIndexes.append(index)
                }
                
                for i in dateArray {
                    var cellDatecomponents = DateComponents()
                    var senderDatecomponets = DateComponents()
                    cellDatecomponents.day = calendar.dateComponents([.day], from: i).day
                    cellDatecomponents.month = calendar.dateComponents([.month], from: i).month
                    cellDatecomponents.year = calendar.dateComponents([.year], from: i).year
                    
                    senderDatecomponets.day = calendar.dateComponents([.day], from: sender).day
                    senderDatecomponets.month = calendar.dateComponents([.month], from: sender).month
                    senderDatecomponets.year = calendar.dateComponents([.year], from: sender).year
                    
                    if cellDatecomponents == senderDatecomponets && item.id > 10000 {
                        currentTrackersIndexes.append(index)
                    }
                }
            }
        }
        return currentTrackersIndexes
    }
    
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

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        NotificationCenter.default.post(name: NotificationNames.coreDataChange, object: nil)
    }
}
