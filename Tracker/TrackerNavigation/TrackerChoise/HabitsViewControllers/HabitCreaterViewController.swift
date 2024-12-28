//
//  File.swift
//  Tracker
//
//  Created by Кирилл Дробин on 18.10.2024.
//

import UIKit

final class HabitCreaterViewController: UIViewController {
    // MARK: - Delegate
    weak var delegate: TrackerSender?    
    
    // MARK: - Private Properties
    private var trackerNameText = String()
    private var date = [Date]()
    private var trackerCategoryName = String()
    private var daysOfWeekShortArray: [String] = []

    private let cellId = "habitcell"
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackerNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.layer.cornerRadius = 16
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingChanged)
        return textField
    }()
    
    private lazy var menu: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.alwaysBounceVertical = false
        return table
    }()
    
    private lazy var canselButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.borderColor = CGColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        button.layer.borderWidth = 1.0
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(named: "YP Red"), for: .normal)
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(createTracker), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        menu.dataSource = self
        menu.delegate = self
        trackerNameTextField.delegate = self
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        menu.dataSource = self
        menu.delegate = self
        menu.reloadData()
        addSubviews()
        makeConstraints()
        
        if trackerNameText.isEmpty == false, trackerCategoryName.isEmpty == false, date.isEmpty == false {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        }
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            label,
            trackerNameTextField,
            trackerNameTextField.textInputView,
            menu,
            canselButton,
            createButton
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
            
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 98),
            trackerNameTextField.textInputView.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
            
            menu.heightAnchor.constraint(equalToConstant: 150),
            menu.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            menu.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            menu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 197),
            
            canselButton.heightAnchor.constraint(equalToConstant: 60),
            canselButton.widthAnchor.constraint(equalToConstant: 166),
            canselButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            canselButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.centerYAnchor.constraint(equalTo: canselButton.centerYAnchor),
            createButton.leadingAnchor.constraint(equalTo: canselButton.trailingAnchor, constant: 8)
        ])
    }
    
    private func clearCellParams() {
        trackerNameText.removeAll()
        trackerCategoryName.removeAll()
        date.removeAll()
        daysOfWeekShortArray.removeAll()
    }
    
    // MARK: - Objc Methods
    @objc private func createTracker() {
        
        let randomId = UInt.random(in: 0..<10000)
        
        delegate?.categoryChecker(id: randomId, trackerCategoryName: trackerCategoryName, trackerNameText: trackerNameText, date: date)
        delegate?.trackerSender(trackerData: Tracker(id: randomId, trackerName: trackerNameText, trackerDate: date))
        NotificationCenter.default.post(name: .valueChange, object: nil)

        dismissViewController()
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    @objc private func textFieldDidEndEditing() {
        trackerNameText = trackerNameTextField.text ?? ""
    }
}

// MARK: - extension HabitCreaterViewController
extension HabitCreaterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = UIColor(red: 174/255, green: 174/255, blue: 180/255, alpha: 1)
        
        
        if (indexPath.row == 0) {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = trackerCategoryName
            cell.separatorInset = .init(top: 30, left: 16, bottom: 30, right: 16)
        } else {
            cell.textLabel?.text = "Расписание"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            if daysOfWeekShortArray.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                cell.detailTextLabel?.text = daysOfWeekShortArray.joined(separator: ", ")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let categoryMainViewController = CategoryMainViewController()
            categoryMainViewController.delegate = self
            navigationController?.pushViewController(categoryMainViewController, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - Delegate methods
extension HabitCreaterViewController: DateSenderProtocol, CategoryNameSenderProtocol {
    func dateSender(dateSender: [Date]) {
        date = dateSender
    }
    
    func dateShortSender(daysOfWeekShortArraySender: [String]) {
        self.daysOfWeekShortArray = daysOfWeekShortArraySender
    }
        
    func categoryNameSender(categoryName: String) {
        self.trackerCategoryName = categoryName
    }
}
