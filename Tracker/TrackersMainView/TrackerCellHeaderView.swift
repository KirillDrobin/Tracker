//
//  File.swift
//  Tracker
//
//  Created by Кирилл Дробин on 08.11.2024.
//

import UIKit

final class TrackerHeaderView: UICollectionReusableView {
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
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
