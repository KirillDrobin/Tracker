//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 21.10.2024.
//

import UIKit

final class CategoryMainViewController: UIViewController {
    // MARK: Delegate
    weak var delegate: CategoryNameSenderProtocol?
        
    // MARK: - Private Properties    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let categoryTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 75
        table.layer.cornerRadius = 16
        table.alwaysBounceVertical = false
        table.layer.masksToBounds = true
        return table
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(switchToCategoryCreaterViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            label,
            categoryTableView,
            addButton
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
            
            categoryTableView.heightAnchor.constraint(equalToConstant: 75),
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 98),
            categoryTableView.widthAnchor.constraint(equalToConstant: 343),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 662),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Objc Methods
    @objc private func switchToCategoryCreaterViewController() {
        let categoryCreaterViewController = CategoryCreaterViewController()
        navigationController?.pushViewController(categoryCreaterViewController, animated: true)
    }
}

// MARK: - extension CategoryMainViewController
extension CategoryMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Важное"
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            delegate?.categoryNameSender(categoryName: "")
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            delegate?.categoryNameSender(categoryName: tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "")
        }
    }
}
