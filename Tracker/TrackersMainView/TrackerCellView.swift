//
//  TrackerCellViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 07.11.2024.
//

import UIKit

final class TrackerCellView: UICollectionViewCell {
    // MARK: - Properties
    let trackerRecordStorage = TrackerRecordStorage.shared
    let trackerStorage = TrackerStorage.shared
    let trackersViewController = TrackersViewController.shared
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .natural
        label.sizeToFit()
        return label
    }()
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        return view
    }()
    
    lazy var emojiView: UILabel = {
        let view = UILabel()
        view.frame.size.width = 24
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .center
        return view
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.frame.size.width = 34
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
        button.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    lazy var id: UInt = {
        return id
    }()
    
    lazy var datePickerDate: Date = {
        return datePickerDate
    }()
    
    // MARK: - Cell init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        addSubviews()
        makeConstraints()

        checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
        checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func cellViewInit() {
        print("4")
        let currentDate = Date()
        let calendar = Calendar.current
        var datePicker = DateComponents()
        var trackersDate = DateComponents()
        
        if datePickerDate > currentDate {
            checkButton.isEnabled = false
        } else {
            checkButton.isEnabled = true
        }

        for i in trackerRecordStorage.completedTrackers {
            trackersDate.day = calendar.dateComponents([.day], from: i.date).day
            trackersDate.month = calendar.dateComponents([.month], from: i.date).month
            trackersDate.year = calendar.dateComponents([.year], from: i.date).year
            
            datePicker.day = calendar.dateComponents([.day], from: datePickerDate).day
            datePicker.month = calendar.dateComponents([.month], from: datePickerDate).month
            datePicker.year = calendar.dateComponents([.year], from: datePickerDate).year
           
            if trackersDate == datePicker && i.id == id {
                recordLabelTextMaker(count: countForRecordLabel(id: id))
                checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 0.5)
                break
            } else {
                recordLabelTextMaker(count: countForRecordLabel(id: id))
                checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
                checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
            }
        }
    }
    
    // MARK: - Private Methods
    private func countForRecordLabel(id: UInt) -> Int {
        var count = Int()
        for i in trackerRecordStorage.completedTrackers {
            if i.id == id {
                count += 1
            }
        }
        if trackerRecordStorage.completedTrackers.isEmpty {
            count = 0
        }
        return count
    }
    
    private func recordLabelTextMaker(count: Int) {
        if count == 0 || count >= 5 {
            recordLabel.text = "\(count) дней"
        } else if count == 1 {
            recordLabel.text = "\(count) день"
        } else {
            recordLabel.text = "\(count) дня"
        }
    }
    
    private func addSubviews() {
        [
            cardView,
            titleLabel,
            recordLabel,
            emojiView,
            checkButton,
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 90),
            cardView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            recordLabel.heightAnchor.constraint(equalToConstant: 18),
            recordLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 12),
            recordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            recordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -54),
            
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 13),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            checkButton.heightAnchor.constraint(equalToConstant: 34),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
            checkButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            checkButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
        ])
    }
    
    // MARK: - Objc Methods
    @objc func checkButtonAction() {
        if checkButton.currentImage == UIImage(systemName: "plus") {
            trackerRecordStorage.completedTrackers.append(TrackerRecord(id: id, date: datePickerDate))
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 0.5)
            recordLabelTextMaker(count: countForRecordLabel(id: id))
        } else {
            trackerRecordStorage.completedTrackers.removeAll { trackers in
                let calendar = Calendar.current
                var currentDateComponents = DateComponents()
                var trackersDateComponents = DateComponents()
                currentDateComponents.day = calendar.dateComponents([.day], from: datePickerDate).day
                currentDateComponents.month = calendar.dateComponents([.month], from: datePickerDate).month
                currentDateComponents.year = calendar.dateComponents([.year], from: datePickerDate).year
                
                trackersDateComponents.day = calendar.dateComponents([.day], from: trackers.date).day
                trackersDateComponents.month = calendar.dateComponents([.month], from: trackers.date).month
                trackersDateComponents.year = calendar.dateComponents([.year], from: trackers.date).year
                return trackersDateComponents == currentDateComponents && trackers.id == id
            }
            checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
            checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
            recordLabelTextMaker(count: countForRecordLabel(id: id))
        }
    }
}
