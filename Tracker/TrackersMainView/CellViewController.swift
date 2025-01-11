//
//  TrackerCellViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 07.11.2024.
//

import UIKit

final class TrackerCellViewController: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()

        return label
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.masksToBounds = true
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var emojiView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 68
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3)
        return view
    }()
    
    private lazy var checkView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Add tracker")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
       
       NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
