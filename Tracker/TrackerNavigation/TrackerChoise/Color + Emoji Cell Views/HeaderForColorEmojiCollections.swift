//
//  HeaderForColorEmojiCollections.swift
//  Tracker
//
//  Created by Кирилл Дробин on 03.01.2025.
//

import UIKit

final class HeaderForColorEmojiCollections: UICollectionReusableView {
    // MARK: - Properties
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    // MARK: - Header init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
