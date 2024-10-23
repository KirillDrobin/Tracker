//
//  TrackerChoiceView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 16.10.2024.
//

import UIKit

final class TrackerChoiceViewController: UIViewController {
   
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont(name: "YS Display-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let addHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 16)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(switchToHabitViewController), for: .touchUpInside)
        return button
    }()
    
    private let addEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 16)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        makeConstraints()
    }
    
    @objc private func switchToHabitViewController() {
        let habitViewController = HabitViewController()
        present(habitViewController, animated: true)
    }
    
    private func addSubviews() {
        [
            label,
            addHabitButton,
            addEventButton
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([

            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 114),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -112),
            
            addHabitButton.heightAnchor.constraint(equalToConstant: 60),
            addHabitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addHabitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addHabitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 355),
            
            addEventButton.heightAnchor.constraint(equalToConstant: 60),
            addEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addEventButton.topAnchor.constraint(equalTo: addHabitButton.bottomAnchor, constant: 18),
        ])
    }
}
