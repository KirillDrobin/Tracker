//
//  TrackerStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    // MARK: - Properties
    static let shared = TrackerStore()
    private override init() {}
    
    private let dateformatter = DateFormatter()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Methods
    func fetchCurrentIndexes(calendar: Calendar, sender: Date) -> [Int] {
        
        let request = NSFetchRequest<TrackerCore>(entityName: "TrackerCore")
        
        guard let trackers = try? context.fetch(request) else { return [] }
        let currentDate = sender
        var currentTrackersIndexes = [Int]()
        
        for (index, item) in trackers.enumerated() {
            let dateArray = stringToDateArrayConverter(string: item.trackerDate ?? "trackers Date error")
            
            for i in dateArray {
                var cellDatecomponents = DateComponents()
                var senderDatecomponets = DateComponents()
                
                senderDatecomponets.weekday = calendar.dateComponents([.weekday], from: currentDate).weekday
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
                    
                    senderDatecomponets.day = calendar.dateComponents([.day], from: currentDate).day
                    senderDatecomponets.month = calendar.dateComponents([.month], from: currentDate).month
                    senderDatecomponets.year = calendar.dateComponents([.year], from: currentDate).year
                    
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
            currentTrackerDataArray.append(Tracker(id: trackers[i].id,
                                                   trackerName: trackers[i].trackerName ?? "",
                                                   trackerColor: trackers[i].trackerColor,
                                                   trackerEmoji: trackers[i].trackerEmoji ?? "",
                                                   trackerDate: stringToDateArrayConverter(string: trackers[i].trackerDate ?? "")))
        }
        return currentTrackerDataArray
    }
    
    // MARK: - Private Methods
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
    
    private func stringToDateArrayConverter(string: String) -> [Date] {
        var dateStringArray = [String]()
        var dateArray = [Date]()
        dateStringArray = string.components(separatedBy: ",")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss +Z"
        for i in dateStringArray {
            dateArray.append(dateformatter.date(from: i) ?? Date())
        }
        return dateArray
    }
}
