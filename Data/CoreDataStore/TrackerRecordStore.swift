//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.01.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore {
    // MARK: - Properties
    static let shared = TrackerRecordStore()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
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
        let calendar = Calendar.current
        var datePicker = DateComponents()
        var trackersDate = DateComponents()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCore")
        
        guard let trackerRecord = try? context.fetch(fetchRequest) as? [TrackerRecordCore] else { return }
        for i in trackerRecord {
            
            trackersDate.day = calendar.dateComponents([.day], from: i.date ?? Date()).day
            trackersDate.month = calendar.dateComponents([.month], from: i.date ?? Date()).month
            trackersDate.year = calendar.dateComponents([.year], from: i.date ?? Date()).year
            
            datePicker.day = calendar.dateComponents([.day], from: cellDate).day
            datePicker.month = calendar.dateComponents([.month], from: cellDate).month
            datePicker.year = calendar.dateComponents([.year], from: cellDate).year
            
            if i.id == cellId && trackersDate == datePicker {
                context.delete(i)
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
        
       guard let trackersRecord = try? context.fetch(request) else { return false }
        
        for i in trackersRecord {
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
        let fetchRequest = NSFetchRequest<TrackerRecordCore>(entityName: "TrackerRecordCore")
        let trackerRecord = try? context.fetch(fetchRequest)
        guard let trackerRecord else { return .zero }
        var countRecord = Int()
        for i in trackerRecord {
            if i.id == id { countRecord += 1 }
        }
        return countRecord
    }
}
