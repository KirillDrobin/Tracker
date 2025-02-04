//
//  ChoiseCategoryViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 21.10.2024.
//

import UIKit

final class CategoryCreaterViewController: UIViewController {
    // MARK: - Singletone
    private let categoryMainViewModel = CategoryMainViewModel.shared
    private let storage = Storage.shared
        
    // MARK: - Private Properties
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let categoryNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Введите название категории"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.layer.cornerRadius = 16
        textField.addTarget(self, action: #selector(unlockCategoryButton), for: .editingChanged)
        return textField
    }()
    
    private let warningTextLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(red: 245, green: 107, blue: 108, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let createCategoryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.isEnabled = false
        button.addTarget(self, action: #selector(createCategoryButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameTextField.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Private Methods  
    private func addSubviews() {
        [
            label,
            categoryNameTextField,
            categoryNameTextField.textInputView,
            createCategoryButton
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
            
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryNameTextField .topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 98),
            
            categoryNameTextField.textInputView.leadingAnchor.constraint(equalTo: categoryNameTextField.leadingAnchor, constant: 16),
            
            createCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createCategoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 662),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Objc Methods
    @objc private func createCategoryButtonAction() {
//        storage.trackerCategoryNameArray.append(categoryNameTextField.text ?? "")
//        categoryMainViewModel.cellCount = storage.trackerCategoryNameArray.count
//        categoryMainViewModel.trackerCategoryNameArraySet(sender: categoryNameTextField.text ?? "")
        categoryMainViewModel.saveCategory(trackerCategoryName: categoryNameTextField.text ?? "nil value, error")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func unlockCategoryButton() {
        let isNotEmptyText = categoryNameTextField.text?.isEmpty == false
        createCategoryButton.isEnabled = isNotEmptyText
        createCategoryButton.backgroundColor = isNotEmptyText ? .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        if categoryNameTextField.text?.count == 38 { /*toDo ограничение названия категории в 38 символов*/ }
    }
}
