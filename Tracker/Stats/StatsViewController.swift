//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 06.10.2024.
//

import UIKit

final class StatsViewController: UIViewController {
    
    var gradient: CAGradientLayer?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Статистика", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let bestPeriodCard: UIView = {
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x : 0.0, y : 0)
//        gradient.endPoint = CGPoint(x :0.0, y: 1)
        
        let card = UIView()
//        card.backgroundColor = .clear
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.red.cgColor
//        gradient.frame = card.bounds
//        self.gradient = card.setGradie
//        card.layer.addSublayer(gradient)
        
        return card
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsWithCollection()
        makeConstraintsWithCollection()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
//    private func addSubviewsDefault() {
//        [
//            label,
//            bestPeriodCard
//        ].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview($0)
//        }
//    }
    
    private func addSubviewsWithCollection() {
        [
            label,
            bestPeriodCard
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
//    private func makeConstraintsDefault() {
//        NSLayoutConstraint.activate([
//            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
//            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
//            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
//            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
//            
//            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor, constant: 0),
//            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
////            datePicker.widthAnchor.constraint(equalToConstant: 77),
//            
//            label.widthAnchor.constraint(equalToConstant: 254),
//            label.heightAnchor.constraint(equalToConstant: 41),
//            label.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 1),
//            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            
//            searchField.heightAnchor.constraint(equalToConstant: 36),
//            searchField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
//            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            
//            mainTrackersViewImage.heightAnchor.constraint(equalToConstant: 80),
//            mainTrackersViewImage.widthAnchor.constraint(equalToConstant: 80),
//            mainTrackersViewImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
//            mainTrackersViewImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            
//            mainTrackersViewImageLabel.topAnchor.constraint(equalTo: mainTrackersViewImage.bottomAnchor, constant: 8),
//            mainTrackersViewImageLabel.leadingAnchor.constraint(equalTo: mainTrackersViewImage.leadingAnchor, constant: -131),
//            mainTrackersViewImageLabel.trailingAnchor.constraint(equalTo: mainTrackersViewImage.trailingAnchor, constant: 132)
//        ])
//    }
    
    private func makeConstraintsWithCollection() {
        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalToConstant: 254),
            label.heightAnchor.constraint(equalToConstant: 41),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            bestPeriodCard.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 77),
            bestPeriodCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bestPeriodCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bestPeriodCard.heightAnchor.constraint(equalToConstant: 90),
            
        ])
    }
    
}
