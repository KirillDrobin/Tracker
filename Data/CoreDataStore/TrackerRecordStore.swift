//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    // MARK: - Properties
    static let shared = TrackerRecordStore()
    private override init() {}
        
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Methods
    func recordSet(cellId: Int64, cellDate: Date) {
        let trackerRecord = TrackerRecordCore(context: context)
        
        trackerRecord.id = cellId
        trackerRecord.date = cellDate
        
        appDelegate.saveContext()
    }
    
    func recordDel(cellId: Int64, cellDate: Date) {
        let fetchRequest = NSFetchRequest<TrackerRecordCore>(entityName: "TrackerRecordCore")
        
        guard let trackerRecord = try? context.fetch(fetchRequest) else { return }
        for i in trackerRecord {
            if i.id == cellId && i.date == cellDate {
                context.delete(i)
                break
            }
        }
        appDelegate.saveContext()
    }
    
    func recordChecker(currentDate: Date, id: Int64) -> Bool {
        let calendar = Calendar.current
        var datePicker = DateComponents()
        var trackersDate = DateComponents()
        var returnValue = Bool()
        
        let request = NSFetchRequest<TrackerRecordCore>(entityName: "TrackerRecordCore")
        
        let trackersRecord = try? context.fetch(request)
        
        for i in trackersRecord! {
            trackersDate.day = calendar.dateComponents([.day], from: i.date ?? Date()).day
            trackersDate.month = calendar.dateComponents([.month], from: i.date ?? Date()).month
            trackersDate.year = calendar.dateComponents([.year], from: i.date ?? Date()).year
            
            datePicker.day = calendar.dateComponents([.day], from: currentDate).day
            datePicker.month = calendar.dateComponents([.month], from: currentDate).month
            datePicker.year = calendar.dateComponents([.year], from: currentDate).year
            
            if trackersDate == datePicker && i.id == id {
                returnValue = true
                break
            } else {
                returnValue = false
            }
        }
        return returnValue
    }
    
    func countRecord(id: Int64) -> Int {
        var countRecord = Int()
        let fetchRequest = NSFetchRequest<TrackerRecordCore>(entityName: "TrackerRecordCore")
        let trackerRecord = try? context.fetch(fetchRequest)
        if trackerRecord == nil {
            countRecord = 0
        } else {
            for i in trackerRecord! {
                if i.id == id {
                    countRecord += 1
                }
            }
        }
        return countRecord
    }
}
