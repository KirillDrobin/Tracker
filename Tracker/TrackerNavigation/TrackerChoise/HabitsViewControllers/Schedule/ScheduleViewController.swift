//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 21.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Private Properties
    private let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let daysOfWeekShort = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private var trackerStorage = TrackerStorage.shared
    private var habitCreaterViewController = HabitCreaterViewController.shared
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weekTableView: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.alwaysBounceVertical = false
        table.layer.masksToBounds = true
        table.separatorInset = .init(top: 30, left: 16, bottom: 30, right: 16)
        return table
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerStorage.date.removeAll()
        trackerStorage.daysOfWeekCellTextArray.removeAll()
        view.backgroundColor = .white
        weekTableView.dataSource = self
        weekTableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            label,
            weekTableView,
            readyButton
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
            
            weekTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            weekTableView.heightAnchor.constraint(equalToConstant: 525),
            weekTableView.widthAnchor.constraint(equalToConstant: 343),
            
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            readyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 662),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    private func selectedDaysOfWeekToDateConverter(selectedDayOfWeek: Int) -> Date {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        var datecomponets = DateComponents()
        if selectedDayOfWeek == 7 {
            datecomponets.weekday = 1
        } else {
            datecomponets.weekday = selectedDayOfWeek + 1
        }
        datecomponets.weekOfYear = calendar.dateComponents([.weekOfYear], from: today).weekOfYear
        datecomponets.year = calendar.dateComponents([.year], from: today).year
        guard let selectedDate = calendar.date(from: datecomponets) else { return Date() }
        return selectedDate
    }
    
    // MARK: - Objc Methods
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeDayOfWeek(_ sender: UISwitch) {
        if sender.isOn {
            trackerStorage.date.append(selectedDaysOfWeekToDateConverter(selectedDayOfWeek: sender.tag))
            trackerStorage.daysOfWeekCellTextArray.append(daysOfWeekShort[sender.tag - 1])
        } else {
            trackerStorage.date.removeAll { value in
                return value == selectedDaysOfWeekToDateConverter(selectedDayOfWeek: sender.tag)
            }
            trackerStorage.daysOfWeekCellTextArray.removeAll { value in
                return value == daysOfWeekShort[sender.tag - 1]
            }
        }
    }
}

// MARK: - extension ScheduleViewController
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //switch
        let uiSwitch = UISwitch(frame: .zero)
        uiSwitch.setOn(false, animated: true)
        uiSwitch.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        uiSwitch.tag = indexPath.row + 1
        uiSwitch.addTarget(self, action: #selector(changeDayOfWeek), for: .touchUpInside)
        
        //cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if (indexPath.row == 6) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        cell.imageView?.image = UIImage(named: "chevron.right")
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.accessoryView = uiSwitch
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    

}
