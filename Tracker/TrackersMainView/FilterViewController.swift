//
//  FilterViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 03.02.2025.
//

import UIKit

final class FilterViewController: UIViewController {
    // MARK: - Delegate
    weak var delegate: FilterProtocol?
    
    // MARK: - Singletone
    private let storage = Storage.shared
    
    // MARK: - Singletone
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Фильтры", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let filtersTableView: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.backgroundColor = UIColor(named: "TextFieldTableViewSet")
        table.separatorColor = UIColor(named: "SeparatorSet")
        return table
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundSet")
        navigationController?.navigationBar.isHidden = true
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }

    // MARK: - Private Methods
    private func addSubviews() {
        [
            label,
            filtersTableView
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
            
            filtersTableView.heightAnchor.constraint(equalToConstant: 300),
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filtersTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),

        ])
    }
    
}

// MARK: - extension FilterViewController
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        cell.backgroundColor = UIColor(named: "TextFieldTableViewSet")
        cell.separatorInset = .init(top: 30, left: 16, bottom: 30, right: 16)
        
        if storage.trackerViewStatus == indexPath.row + 1 {
            cell.accessoryType = .checkmark
        }
        
        if indexPath.row == 0  {
            cell.textLabel?.text = NSLocalizedString("Все трекеры", comment: "")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString("Трекеры на сегодня", comment: "")
        } else if indexPath.row == 2 {
            cell.textLabel?.text = NSLocalizedString("Завершенные", comment: "")
        } else if indexPath.row == 3 {
            cell.textLabel?.text = NSLocalizedString("Не завершенные", comment: "")
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.reloadData()
        
        if indexPath.row == 0  {
            delegate?.allTrackersFilter()
        } else if indexPath.row == 1 {
            delegate?.trackersForTodayFilter()
        } else if indexPath.row == 2 {
            delegate?.completeTrackersFilter()
        } else if indexPath.row == 3 {
            delegate?.incompleteTrackersFilter()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
