//
//  TrackerChoiceView.swift
//  Tracker
//
//  Created by Кирилл Дробин on 16.10.2024.
//

import UIKit

final class TrackerChoiceViewController: UIViewController {
    
    weak var delegate: TrackerSender?
    
    // MARK: - Private Properties
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Создание трекера", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Привычка", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.backgroundColor = UIColor(named: "Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(switchToHabitViewController), for: .touchUpInside)
        return button
    }()
    
    private let addEventButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Нерегулярное событие", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(named: "White"), for: .normal)
        button.backgroundColor = UIColor(named: "Black")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(switchToUnregularEventCreaterViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundSet")
        self.navigationController?.navigationBar.isHidden = true
        addSubviews()
        makeConstraints()
    }

    // MARK: - Private Methods
    private func addSubviews() {
        [
            label,
            addHabitButton,
            addEventButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
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
    
    // MARK: - Objc Methods
    @objc private func switchToHabitViewController() {
        let habitCreaterViewController = HabitCreaterViewController()
        habitCreaterViewController.delegate = delegate
        navigationController?.pushViewController(habitCreaterViewController, animated: true)
    }
    
    @objc private func switchToUnregularEventCreaterViewController() {
        let unregularEventCreaterViewController = UnregularEventCreaterViewController()
        unregularEventCreaterViewController.delegate = delegate
        navigationController?.pushViewController(unregularEventCreaterViewController, animated: true)
    }
}
