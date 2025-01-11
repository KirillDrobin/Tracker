//
//  ColorCellView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 31.12.2024.
//

import UIKit

final class ColorCellView: UICollectionViewCell {
    
    let colorCell: UIView = {
        let cell = UIView()
        cell.layer.cornerRadius = 8
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [
            colorCell
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            colorCell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCell.widthAnchor.constraint(equalToConstant: 40),
            colorCell.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func colorSetup(color: UIColor) {
        colorCell.backgroundColor = color
    }
}
