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
    
    init () {
        super.init(nibName: nil, bundle: nil)
        viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        vcInit()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        vcInit()
        bind()

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
            
            categoryTableView.heightAnchor.constraint(equalToConstant: categoryTableViewHeightUpdate()),
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
    
    private func vcInit() {
        categoryMainViewModel.vcInitStatus()
        if categoryMainViewModel.vcInitStatus() == false {
            categoryTableView.dataSource = self
            categoryTableView.delegate = self
            addSubviewsWithTableView()
            makeConstraintsWithTableView()
            defaultViewImage.isHidden = true
            defaultViewImageLabel.isHidden = true
        } else {
            addSubviewsDefault()
            makeConstraintsDefault()
        }
    }
    
    private func bind() {
        categoryMainViewModel.categoriesChange = { [weak self] trackerCategoryNameArray in
            self?.categoryTableView.reloadData()
        }
    }
    
    private func categoryTableViewHeightUpdate() -> CGFloat {

        if categoryMainViewModel.categoryTableViewHeightUpdate() == true {
            return CGFloat(524)
        } else {
            return CGFloat(74 * categoryMainViewModel.cellCount)
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
        return categoryMainViewModel.trackerCategoryNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = categoryMainViewModel.trackerCategoryNameArray[indexPath.row]
        cell.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        cell.separatorInset = .init(top: 30, left: 16, bottom: 30, right: 16)
        
        if indexPath.row + 1 == categoryMainViewModel.trackerCategoryNameArray.count {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
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
