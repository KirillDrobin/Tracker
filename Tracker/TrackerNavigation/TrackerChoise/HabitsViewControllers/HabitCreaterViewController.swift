//
//  File.swift
//  Tracker
//
//  Created by Кирилл Дробин on 18.10.2024.
//

import UIKit

final class HabitCreaterViewController: UIViewController {
    // MARK: - Singletone
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private var categoryMainViewModel = CategoryMainViewModel.shared
    
    // MARK: - Delegate
    weak var delegate: TrackerSender?
    
    // MARK: - Private Properties
    private var habitCreaterViewControllerObserver: NSObjectProtocol?
    
    private var trackerNameText = String()
    private var date = [Date]()
    private var trackerCategoryName = String()
    private var emoji = String()
    private var daysOfWeekShortArray: [String] = []
    private var colorInt = Int16()
    private var colorCellStatus = 0
    
    private let cellId = "habitcell"
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let trackerNameTextField: CustomTextField = {
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
    
    private let habitSetupsTableView: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 16
        table.alwaysBounceVertical = false
        return table
    }()
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let canselButton: UIButton = {
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
    
    private let createButton: UIButton = {
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
        
        habitSetupsTableView.dataSource = self
        habitSetupsTableView.delegate = self
        trackerNameTextField.delegate = self
        
        emojiCollectionView.register(EmojiCellView.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.register(HeaderForColorEmojiCollections.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        colorCollectionView.register(ColorCellView.self, forCellWithReuseIdentifier: "colorCell")
        colorCollectionView.register(HeaderForColorEmojiCollections.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        habitSetupsTableView.reloadData()
        addSubviews()
        makeConstraints()
        
        self.habitCreaterViewControllerObserver = NotificationCenter.default.addObserver(
            forName: NotificationNames.buttonIsEnabled,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.didEnabledButton()
        }
        trackerCategoryNameUpdate()
    }

    deinit {
        habitCreaterViewControllerObserver = nil
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(scrollView)
        [
            label,
            trackerNameTextField,
            trackerNameTextField.textInputView,
            habitSetupsTableView,
            emojiCollectionView,
            colorCollectionView,
            canselButton,
            createButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 38),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 114),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -112),
            
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 98),
            trackerNameTextField.textInputView.leadingAnchor.constraint(equalTo: trackerNameTextField.leadingAnchor, constant: 16),
            
            habitSetupsTableView.heightAnchor.constraint(equalToConstant: 150),
            habitSetupsTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitSetupsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            habitSetupsTableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 197),
            
            emojiCollectionView.topAnchor.constraint(equalTo: habitSetupsTableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 34),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            canselButton.heightAnchor.constraint(equalToConstant: 60),
            canselButton.widthAnchor.constraint(equalToConstant: 166),
            canselButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            canselButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            canselButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.centerYAnchor.constraint(equalTo: canselButton.centerYAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func clearCellParams() {
        trackerNameText.removeAll()
        trackerCategoryName.removeAll()
        date.removeAll()
        daysOfWeekShortArray.removeAll()
        emoji.removeAll()
        colorInt = Int16()
    }
    
    private func didEnabledButton() {
        if trackerNameText.isEmpty == false,
           trackerCategoryName.isEmpty == false,
           date.isEmpty == false,
           emoji.isEmpty == false,
           colorCellStatus != 0 {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        }
    }
    
    private func trackerCategoryNameUpdate() {
        trackerCategoryName = categoryMainViewModel.selectedCategoryName
    }
    
    // MARK: - Objc Methods
    @objc private func createTracker() {
        
        let randomId = Int64.random(in: 0..<10000)
        
        trackerCategoryStore.trackerAndCategoryCreater(trackerCategoryName: trackerCategoryName,
                                                       tracker: Tracker(id: randomId,
                                                                        trackerName: trackerNameText,
                                                                        trackerColor: colorInt,
                                                                        trackerEmoji: emoji,
                                                                        trackerDate: date))
        
        NotificationCenter.default.post(name: NotificationNames.coreDataChange, object: nil)
        
        dismissViewController()
    }
    
    @objc private func dismissViewController() {
        delegate?.trackersViewControllerReloader()
        clearCellParams()
        self.dismiss(animated: true)
    }
    
    @objc private func textFieldDidEndEditing() {
        trackerNameText = trackerNameTextField.text ?? ""
        NotificationCenter.default.post(name: NotificationNames.buttonIsEnabled, object: nil)
    }
}

// MARK: - extension HabitCreaterViewController: TableView Setup
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
        if indexPath.row == .zero {
            let categoryMainViewController = CategoryMainViewController()
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

// MARK: - extension HabitCreaterViewController: CollectionView Setups
extension HabitCreaterViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.colorsForCell.count
    }
    
    //cell setup
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCellView
            cell?.emojiSetup(emoji: Constants.emojisForCell[indexPath.item])
            return cell ?? EmojiCellView()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCellView
            cell?.colorSetup(color: Constants.colorsForCell[indexPath.item])
            return cell ?? ColorCellView()
        }
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { CGSize(width: 52, height: 52) }
    
    // header setup
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: id,
                                                                         for: indexPath) as? HeaderForColorEmojiCollections else { return UICollectionReusableView() }
        
        if collectionView == emojiCollectionView {
            view.headerLabel.text = "Emoji"
            return view
        } else {
            view.headerLabel.text = "Цвет"
            return view
        }
    }
    
    // header size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width - 28, height: 18),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    // collectionView setups
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 5 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { .zero }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
    
    // collectionView actions
    // did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView
            cell?.contentView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
            cell?.contentView.layer.cornerRadius = 16
            emoji = cell?.emojiCell.text ?? ""
            NotificationCenter.default.post(name: NotificationNames.buttonIsEnabled, object: nil)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView
            cell?.contentView.layer.borderWidth = 3
            cell?.contentView.layer.borderColor = cell?.colorCell.backgroundColor?.withAlphaComponent(0.3).cgColor
            cell?.contentView.layer.cornerRadius = 8
            colorInt = Int16(indexPath.item)
            colorCellStatus = 1
            NotificationCenter.default.post(name: NotificationNames.buttonIsEnabled, object: nil)
        }
    }
    
    // did deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCellView
            cell?.contentView.backgroundColor = .clear
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCellView
            cell?.contentView.layer.borderWidth = .zero
            colorCellStatus = 0
        }
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
