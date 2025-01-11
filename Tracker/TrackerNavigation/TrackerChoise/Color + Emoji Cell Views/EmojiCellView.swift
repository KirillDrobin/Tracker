//
//  EmojiCellView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 31.12.2024.
//

import UIKit

final class EmojiCellView: UICollectionViewCell {
    
    let emojiCell: UILabel = {
        let cell = UILabel()
        cell.font = .systemFont(ofSize: 32)
        cell.textAlignment = .center
        cell.layer.cornerRadius = 19
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
            emojiCell
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            emojiCell.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiCell.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiCell.widthAnchor.constraint(equalToConstant: 40),
            emojiCell.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func emojiSetup(emoji: String) {
        emojiCell.text = emoji
    }
}
