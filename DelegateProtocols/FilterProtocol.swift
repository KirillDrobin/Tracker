//
//  FilterProtocol.swift
//  Tracker
//
//  Created by Кирилл Дробин on 09.02.2025.
//

import Foundation

protocol FilterProtocol: AnyObject {
    func allTrackersFilter()
    func trackersForTodayFilter()
    func completeTrackersFilter()
    func incompleteTrackersFilter()
}
