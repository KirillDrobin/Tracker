//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 21.10.2024.
//

import UIKit

final class CategoryMainViewController: UIViewController {
    // MARK: - Singletone
    private var categoryMainViewModel = CategoryMainViewModel.shared
    
    // MARK: - Private Properties
    private var sectionCount = Int()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let defaultViewImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrackersDefaultLogo")
        return image
    }()
    
    private let defaultViewImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let categoryTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 75
        table.layer.cornerRadius = 16
        table.alwaysBounceVertical = false
        table.layer.masksToBounds = true
        table.isScrollEnabled = true
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
        DispatchQueue.main.async { [weak self] in
            self?.bind()
        }
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async { [weak self] in
            self?.bind()
        }
    }
    
    // MARK: - Private Methods
    private func addSubviewsDefault() {
        [
            label,
            defaultViewImage,
            defaultViewImageLabel,
            addButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraintsDefault() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 114),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -112),
            
            defaultViewImage.heightAnchor.constraint(equalToConstant: 80),
            defaultViewImage.widthAnchor.constraint(equalToConstant: 80),
            defaultViewImage.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 246),
            defaultViewImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            defaultViewImageLabel.topAnchor.constraint(equalTo: defaultViewImage.bottomAnchor, constant: 8),
            defaultViewImageLabel.leadingAnchor.constraint(equalTo: defaultViewImage.leadingAnchor, constant: -131),
            defaultViewImageLabel.trailingAnchor.constraint(equalTo: defaultViewImage.trailingAnchor, constant: 132),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 662),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addSubviewsWithTableView() {
        [
            label,
            categoryTableView,
            addButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraintsWithTableView() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 114),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -112),
            
            categoryTableView.heightAnchor.constraint(equalToConstant: 524),
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
    
    private func bind() {
        categoryMainViewModel.currentCategoriesFetch()
        categoryMainViewModel.categoriesChange = { [weak self] bool in
            self?.vcInit(bool: bool)
        }
    }
    
    private func vcInit(bool: Bool) {
        if bool == false {
            categoryTableView.dataSource = self
            categoryTableView.delegate = self
            defaultViewImage.isHidden = true
            defaultViewImageLabel.isHidden = true
            addSubviewsWithTableView()
            makeConstraintsWithTableView()
            categoryTableView.reloadData()
        } else {
            addSubviewsDefault()
            makeConstraintsDefault()
        }
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
        
        categoryMainViewModel.count = { [weak self] count in
            self?.sectionCount = count
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var array = [String]()
        
        categoryMainViewModel.currentCategories = { categoriesAarray in
            array = categoriesAarray
        }
        
        //cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = array[indexPath.row]
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.separatorInset = .init(top: 30, left: 16, bottom: 30, right: 16)
        
        if indexPath.row + 1 == sectionCount {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        categoryMainViewModel.categoryNameSender(name: tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
