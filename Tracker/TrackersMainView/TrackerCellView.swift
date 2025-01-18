//
//  TrackerCellView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 07.11.2024.
//

import UIKit

final class TrackerCellView: UICollectionViewCell {
    // MARK: - Singletone
    private let trackerRecordStore = TrackerRecordStore.shared
    
    // MARK: - Properties
    var id = Int64()
    var datePickerDate = Date()
    
    private let currentDate = Date()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    let recordLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .natural
        label.sizeToFit()
        return label
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
        return view
    }()
    
    let emojiView: UILabel = {
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
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
        button.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        return button
    }()
        
    // MARK: - Cell init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        addSubviews()
        makeConstraints()
        
//        checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
//        checkButton.backgroundColor = UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func cellViewInit() {
        let date = Date()
        
        if datePickerDate > date {
            checkButton.isEnabled = false
        } else {
            checkButton.isEnabled = true
        }
        
        if trackerRecordStore.recordChecker(currentDate: datePickerDate, id: id) == true {
            recordLabelTextMaker(count: trackerRecordStore.countRecord(id: id))
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkButton.backgroundColor = checkButton.backgroundColor?.withAlphaComponent(0.5)
        }
        
        if trackerRecordStore.recordChecker(currentDate: datePickerDate, id: id) == false {
            recordLabelTextMaker(count: trackerRecordStore.countRecord(id: id))
            checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
            checkButton.backgroundColor = checkButton.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    // MARK: - Private Methods
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
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
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
        if checkButton.imageView?.image == UIImage(systemName: "plus") {
            trackerRecordStore.recordSet(cellId: id, cellDate: datePickerDate)

            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkButton.backgroundColor = checkButton.backgroundColor?.withAlphaComponent(0.5)
//            recordLabelTextMaker(count: trackerRecordStore.countRecord(id: id))
            cellViewInit()
        } else {
            trackerRecordStore.recordDel(cellId: id, cellDate: datePickerDate)
            
            checkButton.setImage(UIImage(systemName: "plus"), for: .normal)
            checkButton.backgroundColor = checkButton.backgroundColor?.withAlphaComponent(1)
//            recordLabelTextMaker(count: trackerRecordStore.countRecord(id: id))
            cellViewInit()
        }
    }
}

