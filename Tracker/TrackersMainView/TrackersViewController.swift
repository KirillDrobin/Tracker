//
//  TrackersViewcontroller.swift
//  Tracker
//
//  Created by Кирилл Дробин on 06.10.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Singletone
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    
    // MARK: - Private Properties
    private var trackersViewControllerObserver: NSObjectProtocol?
    private var currentDate = Date()
    private var currentTrackersIndexes = [Int]()
    private var currentTrackerDataArray = [Tracker]()
    
    private let addTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Figma plus"), for: .normal)
        button.addTarget(self, action: #selector(switchToTrackerChoiceViewController), for: .touchUpInside)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.locale = Locale(identifier: "ru_RU")
        date.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return date
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        search.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        search.textColor = .gray
        search.backgroundColor = UIColor(red: 255/118, green: 255/118, blue: 225/128, alpha: 0.12)
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private let mainTrackersViewImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrackersDefaultLogo")
        return image
    }()
    
    private let mainTrackersViewImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        reloadMainScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.trackersViewControllerObserver = NotificationCenter.default.addObserver(
            forName: NotificationNames.coreDataChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.reloadMainScreen()
        }

        dateChecker(datePicker)
    }
    
    deinit {
        trackersViewControllerObserver = nil
    }
    
    // MARK: - Private Methods
    private func reloadMainScreen() {
        if currentTrackersIndexes.isEmpty == false {
            addSubviewsWithCollection()
            makeConstraintsWithCollection()
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(TrackerCellView.self, forCellWithReuseIdentifier: "cell")
            collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        } else {
            addSubviewsDefault()
            makeConstraintsDefault()
        }
        collectionView.reloadData()
    }
    
    private func dateChecker(_ sender: UIDatePicker) {
        currentDate = sender.date
        currentTrackersIndexes.removeAll()
        let calendar = Calendar.current
        
        currentTrackersIndexes = trackerStore.fetchCurrentIndexes(calendar: calendar, sender: currentDate)
        
        currentTrackerDataArray = trackerStore.fetchCurrentTrackersData(currentTrackersIndexes: currentTrackersIndexes)
        
        NotificationCenter.default.post(name: NotificationNames.coreDataChange, object: nil)
    }
    
    private func addSubviewsDefault() {
        [
            addTrackerButton,
            datePicker,
            label,
            searchField,
            mainTrackersViewImage,
            mainTrackersViewImageLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func addSubviewsWithCollection() {
        [
            addTrackerButton,
            datePicker,
            label,
            searchField,
            collectionView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraintsDefault() {
        NSLayoutConstraint.activate([
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor, constant: 0),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            label.widthAnchor.constraint(equalToConstant: 254),
            label.heightAnchor.constraint(equalToConstant: 41),
            label.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 1),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            mainTrackersViewImage.heightAnchor.constraint(equalToConstant: 80),
            mainTrackersViewImage.widthAnchor.constraint(equalToConstant: 80),
            mainTrackersViewImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            mainTrackersViewImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            mainTrackersViewImageLabel.topAnchor.constraint(equalTo: mainTrackersViewImage.bottomAnchor, constant: 8),
            mainTrackersViewImageLabel.leadingAnchor.constraint(equalTo: mainTrackersViewImage.leadingAnchor, constant: -131),
            mainTrackersViewImageLabel.trailingAnchor.constraint(equalTo: mainTrackersViewImage.trailingAnchor, constant: 132)
        ])
    }
    
    private func makeConstraintsWithCollection() {
        NSLayoutConstraint.activate([
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor, constant: 0),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            label.widthAnchor.constraint(equalToConstant: 254),
            label.heightAnchor.constraint(equalToConstant: 41),
            label.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 1),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    // MARK: - Objc Methods
    @objc private func switchToTrackerChoiceViewController() {
        let trackerChoiceViewController = TrackerChoiceViewController()
        trackerChoiceViewController.delegate = self
        let trackerNavigationController = UINavigationController(rootViewController: trackerChoiceViewController)
        present(trackerNavigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dateChecker(sender)
    }
}

// MARK: - extension TrackersViewController
extension TrackersViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return currentTrackersIndexes.count
    }
    
    // cell setup
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCellView else { return TrackerCellView()}

        cell.titleLabel.text = currentTrackerDataArray[indexPath.row].trackerName
        cell.emojiView.text = currentTrackerDataArray[indexPath.row].trackerEmoji
        cell.cardView.backgroundColor = Constants.colorsForCell[Int(currentTrackerDataArray[indexPath.row].trackerColor)]
        cell.checkButton.backgroundColor = Constants.colorsForCell[Int(currentTrackerDataArray[indexPath.row].trackerColor)]
        
        cell.id = currentTrackerDataArray[indexPath.row].id
        cell.datePickerDate = datePicker.date
        
        cell.cellViewInit()
        return cell
    }
    
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
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: id,
                                                                   for: indexPath) as? TrackerHeaderView
        view?.headerLabel.text = trackerCategoryStore.categoryNameFetch()
        return view ?? TrackerHeaderView()
    }
    
    // header size category
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
    
    // cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellHeight: CGFloat = 148.0
        let cellsPerRow: CGFloat = 2.0
        let cellSpacing: CGFloat = 9.0
        
        let paddingWidth: CGFloat = (cellsPerRow - 1) * cellSpacing
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / CGFloat(cellsPerRow)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 9 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { .zero }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

extension TrackersViewController: TrackerSender {
    func trackersViewControllerReloader() {
        viewWillAppear(true)
    }
}

