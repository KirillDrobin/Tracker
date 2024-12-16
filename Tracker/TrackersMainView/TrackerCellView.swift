//
//  TrackerCellViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 07.11.2024.
//

import UIKit

final class TrackerCellView: UICollectionViewCell {
    
    let trackerRecordStorage = TrackerRecordStorage.shared
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .natural
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.text = "Покормить кота"        
        return label
    }()
    
    lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.text = "0 день"
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
        view.text = "❤️"
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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [
            cardView,
            titleLabel,
            recordLabel,
            emojiView,
            checkButton
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
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 44),
            
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
    
    @objc func checkButtonAction(id: UInt) {
        if checkButton.currentImage == UIImage(systemName: "plus") {
            let date = Date()
            
            if trackerRecordStorage.completedTrackers.isEmpty == false {
                for (key, value) in trackerRecordStorage.completedTrackers {
                    var dateComplete = value
                    if key == id {
                        dateComplete = date
                        trackerRecordStorage.completedTrackers.updateValue(dateComplete, forKey: key)
                        print("\(trackerRecordStorage.completedTrackers)")
                    }
                }
            } else {
                trackerRecordStorage.completedTrackers.updateValue(date, forKey: id)
                print("\(trackerRecordStorage.completedTrackers)")
            }

            print("трекер выполнен: \(trackerRecordStorage.completedTrackers)")
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 0.5)
        } else {
            let date = Date()
            trackerRecordStorage.completedTrackers.removeAll { trackers in
                return trackers.trackerRecord == [id: date]
            }
            print("трекер выполнен: \(trackerRecordStorage.completedTrackers)")
            checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
            checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        }
    }
}
