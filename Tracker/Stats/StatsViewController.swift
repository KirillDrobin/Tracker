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
        let card = UIView()
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.red.cgColor
        return card
    }()
    
    private let bestPeriodCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "9"
        return label
    }()
    
    private let bestPeriodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("Лучший период", comment: "")
        return label
    }()
    
    private let perfectDaysCard: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.red.cgColor
        return card
    }()
    
    private let perfectDaysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "9"
        
        return label
    }()
    
    private let perfectDaysDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("Идеальные дни", comment: "")
        return label
    }()
    
    private let trackersCompleteCard: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.red.cgColor
        return card
    }()
    
    private let trackersCompleteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "9"
        
        return label
    }()
    
    private let trackersCompleteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("Трекеров завершено", comment: "")
        return label
    }()
    
    private let averageValueCard: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.red.cgColor
        return card
    }()
    
    private let averageValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "9"
        
        return label
    }()
    
    private let averageValueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = NSLocalizedString("Среднее значение", comment: "")
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
        
//        addSubviewsWithStatistics()
//        makeConstraintsWithStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    //    private func addSubviewsWithStatistics() {
    //        [
    //            label,
    //
    //            bestPeriodCard,
    //            bestPeriodCountLabel,
    //            bestPeriodDescriptionLabel,
    //
    //            perfectDaysCard,
    //            perfectDaysCountLabel,
    //            perfectDaysDescriptionLabel,
    //
    //            trackersCompleteCard,
    //            trackersCompleteCountLabel,
    //            trackersCompleteDescriptionLabel,
    //
    //            averageValueCard,
    //            averageValueLabel,
    //            averageValueDescriptionLabel
    //        ].forEach {
    //            $0.translatesAutoresizingMaskIntoConstraints = false
    //            view.addSubview($0)
    //        }
    //    }
    //
    //    private func makeConstraintsWithStatistics() {
    //        NSLayoutConstraint.activate([
    //
    //            label.widthAnchor.constraint(equalToConstant: 254),
    //            label.heightAnchor.constraint(equalToConstant: 41),
    //            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
    //            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    //
    //            bestPeriodCard.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 77),
    //            bestPeriodCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    //            bestPeriodCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    //            bestPeriodCard.heightAnchor.constraint(equalToConstant: 90),
    //
    //            bestPeriodCountLabel.topAnchor.constraint(equalTo: bestPeriodCard.topAnchor, constant: 12),
    //            bestPeriodCountLabel.leadingAnchor.constraint(equalTo: bestPeriodCard.leadingAnchor, constant: 12),
    //
    //            bestPeriodDescriptionLabel.topAnchor.constraint(equalTo: bestPeriodCard.topAnchor, constant: 60),
    //            bestPeriodDescriptionLabel.leadingAnchor.constraint(equalTo: bestPeriodCard.leadingAnchor, constant: 12),
    //
    //            perfectDaysCard.topAnchor.constraint(equalTo: bestPeriodCard.bottomAnchor, constant: 12),
    //            perfectDaysCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    //            perfectDaysCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    //            perfectDaysCard.heightAnchor.constraint(equalToConstant: 90),
    //
    //            perfectDaysCountLabel.topAnchor.constraint(equalTo: perfectDaysCard.topAnchor, constant: 12),
    //            perfectDaysCountLabel.leadingAnchor.constraint(equalTo: perfectDaysCard.leadingAnchor, constant: 12),
    //
    //            perfectDaysDescriptionLabel.topAnchor.constraint(equalTo: perfectDaysCard.topAnchor, constant: 60),
    //            perfectDaysDescriptionLabel.leadingAnchor.constraint(equalTo: perfectDaysCard.leadingAnchor, constant: 12),
    //
    //            trackersCompleteCard.topAnchor.constraint(equalTo: perfectDaysCard.bottomAnchor, constant: 12),
    //            trackersCompleteCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    //            trackersCompleteCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    //            trackersCompleteCard.heightAnchor.constraint(equalToConstant: 90),
    //
    //            trackersCompleteCountLabel.topAnchor.constraint(equalTo: trackersCompleteCard.topAnchor, constant: 12),
    //            trackersCompleteCountLabel.leadingAnchor.constraint(equalTo: trackersCompleteCard.leadingAnchor, constant: 12),
    //
    //            trackersCompleteDescriptionLabel.topAnchor.constraint(equalTo: trackersCompleteCard.topAnchor, constant: 60),
    //            trackersCompleteDescriptionLabel.leadingAnchor.constraint(equalTo: trackersCompleteCard.leadingAnchor, constant: 12),
    //
    //            averageValueCard.topAnchor.constraint(equalTo: trackersCompleteCard.bottomAnchor, constant: 12),
    //            averageValueCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    //            averageValueCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    //            averageValueCard.heightAnchor.constraint(equalToConstant: 90),
    //
    //            averageValueLabel.topAnchor.constraint(equalTo: averageValueCard.topAnchor, constant: 12),
    //            averageValueLabel.leadingAnchor.constraint(equalTo: averageValueCard.leadingAnchor, constant: 12),
    //
    //            averageValueDescriptionLabel.topAnchor.constraint(equalTo: averageValueCard.topAnchor, constant: 60),
    //            averageValueDescriptionLabel.leadingAnchor.constraint(equalTo: averageValueCard.leadingAnchor, constant: 12),
    //
    //        ])
    //    }
    
}
