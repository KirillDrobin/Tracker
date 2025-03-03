//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 06.10.2024.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let gradient = CAGradientLayer()
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Статистика", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let trackersCompleteCard: UIView = {
        let card = UIView()
        card.layer.masksToBounds = true
        card.backgroundColor = .clear
        card.layer.cornerRadius = 16
        return card
    }()
    
    private let trackersCompleteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return label
    }()
    
    private let trackersCompleteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("Трекеров завершено", comment: "")
        return label
    }()
    
    // View Placeholder
    private let defaultStatsViewImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultStatsViewImage")
        return image
    }()
    
    private let defaultStatsViewImageLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Анализировать пока нечего", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
        
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsDefault()
        makeConstraintsDefault()
        addSubviewsWithStatistics()
        makeConstraintsWithStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if trackerRecordStore.completeTrackersCount() == 0 {
            trackersCompleteDescriptionLabel.isHidden = true
            trackersCompleteCountLabel.isHidden = true
            trackersCompleteCard.isHidden = true
            defaultStatsViewImage.isHidden = false
            defaultStatsViewImageLabel.isHidden = false
        } else {
            trackersCompleteDescriptionLabel.isHidden = false
            trackersCompleteCountLabel.isHidden = false
            trackersCompleteCard.isHidden = false
            defaultStatsViewImage.isHidden = true
            defaultStatsViewImageLabel.isHidden = true
        }
        
        trackersCompleteCountLabel.text = "\(trackerRecordStore.completeTrackersCount())"
        
        if trackerRecordStore.completeTrackersCount() == 0 || trackerRecordStore.completeTrackersCount() >= 5 {
            trackersCompleteDescriptionLabel.text = "Трекеров завершено"
        } else if trackerRecordStore.completeTrackersCount() == 1 {
            trackersCompleteDescriptionLabel.text = "Трекер завершен"
        } else {
            trackersCompleteDescriptionLabel.text = "Трекера завершено"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradient.frame = trackersCompleteCard.bounds
        setupGradient()
    }
    
        private func addSubviewsDefault() {
            [
                label,
                defaultStatsViewImage,
                defaultStatsViewImageLabel
            ].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        }
    
        private func makeConstraintsDefault() {
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 254),
                label.heightAnchor.constraint(equalToConstant: 41),
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
                label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    
                defaultStatsViewImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                defaultStatsViewImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
    
                defaultStatsViewImage.heightAnchor.constraint(equalToConstant: 80),
                defaultStatsViewImage.widthAnchor.constraint(equalToConstant: 80),
                defaultStatsViewImage.topAnchor.constraint(equalTo: label.topAnchor, constant: 321),
                defaultStatsViewImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
    
                defaultStatsViewImageLabel.topAnchor.constraint(equalTo: defaultStatsViewImage.bottomAnchor, constant: 8),
                defaultStatsViewImageLabel.centerXAnchor.constraint(equalTo: defaultStatsViewImage.centerXAnchor),
    
            ])
        }
        
    private func addSubviewsWithStatistics() {
        [
            label,
            trackersCompleteCard,
            trackersCompleteCountLabel,
            trackersCompleteDescriptionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraintsWithStatistics() {
        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalToConstant: 254),
            label.heightAnchor.constraint(equalToConstant: 41),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            trackersCompleteCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            trackersCompleteCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCompleteCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackersCompleteCard.heightAnchor.constraint(equalToConstant: 90),
            
            trackersCompleteCountLabel.topAnchor.constraint(equalTo: trackersCompleteCard.topAnchor, constant: 12),
            trackersCompleteCountLabel.leadingAnchor.constraint(equalTo: trackersCompleteCard.leadingAnchor, constant: 12),
            
            trackersCompleteDescriptionLabel.topAnchor.constraint(equalTo: trackersCompleteCard.topAnchor, constant: 60),
            trackersCompleteDescriptionLabel.leadingAnchor.constraint(equalTo: trackersCompleteCard.leadingAnchor, constant: 12)
        ])
    }
    
    private func setupGradient() {
    gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    gradient.cornerRadius = 16
    gradient.frame = trackersCompleteCard.bounds
    
    let shape = CAShapeLayer()
    shape.lineWidth = 1
    shape.path = UIBezierPath(roundedRect:
                                trackersCompleteCard.bounds.insetBy(dx: 1, dy: 1),
                              cornerRadius: 16).cgPath
    
    shape.strokeColor = UIColor.black.cgColor
    shape.fillColor = UIColor.clear.cgColor
    gradient.mask = shape
        self.trackersCompleteCard.layer.addSublayer(gradient)
}
}
