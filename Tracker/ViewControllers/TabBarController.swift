//
//  MainView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 03.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        tabBar.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
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

