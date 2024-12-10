//
//  TrackersStorage.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.10.2024.
//

import Foundation

final class TrackerCategoryStorage {
    static let shared = TrackerCategoryStorage()
    var trackerCategoryName = String()
    var categories: [TrackerCategory] = []
}
