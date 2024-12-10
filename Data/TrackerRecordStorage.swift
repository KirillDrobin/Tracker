//
//  TrackerRecordStorage.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.10.2024.
//

import Foundation

final class TrackerRecordStorage {
    static let shared = TrackerRecordStorage()
    var completedTrackers = [TrackerRecord]()
}
