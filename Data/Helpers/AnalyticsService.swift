//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Кирилл Дробин on 02.02.2025.
//

import Foundation
import YandexMobileMetrica


enum Events: String {
    case open
    case close
    case click
    
    var event: String {
        switch self {
        case .open:
            return "open"
        case .close:
            return "close"
        case .click:
            return "click"
        }
    }
}

enum Items: String {
    
    case addTrack
    case track
    case filter
    case edit
    case delete
    case noItem
    
    var item: String {
        switch self {
        case .addTrack:
            return "add_track"
        case .track:
            return "track"
        case .filter:
            return "filter"
        case .edit:
            return "edit"
        case .delete:
            return "delete"
        case .noItem:
            return "no_item"
        }
    }
}

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "86dd958e-54d2-431c-baab-f598105bf0d6") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Events, screen: String, item: Items) {
        let message = "event: \(event), on screen: \(screen), with item: \(item)"
        
        YMMYandexMetrica.reportEvent(message, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        print("report \(message)")
    }

}
