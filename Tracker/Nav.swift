//
//  Nav.swift
//  Tracker
//
//  Created by Кирилл Дробин on 29.10.2024.
//

import UIKit

class TrackerNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationBar.isHidden = true
        
        // initialization TrackersViewController
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers TabBar"),
            selectedImage: nil)
        
        // initialization StatisticsViewController
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Stats TabBar"),
            selectedImage: nil)
        
        
        
        self.viewControllers = [trackersViewController, statsViewController]
    }
}
