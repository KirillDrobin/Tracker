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
    private let trackerFixStore = TrackerFixStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerCategoryFixStore = TrackerCategoryFixStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let storage = Storage.shared
    
    // MARK: - Private Properties
    private var trackersViewControllerObserver: NSObjectProtocol?
    private var currentDate = Date()
    //    private var currentTrackersIndexes = [Int]()
    private var currentTrackerDataArray = [Tracker]()
    
    private var currentTrackerData = [TrackerCategory]()
    
//    private var currentCategories = [TrackerCategory]()
    //    private var filteredTrackerDataArray = [Tracker]()
    private var analyticsService = AnalyticsService()
    
    private let addTrackerButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image?.withTintColor(UIColor(named: "Black") ?? UIColor(), renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(switchToTrackerChoiceViewController), for: .touchUpInside)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.layer.cornerRadius = 8
        date.layer.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.locale = Locale(identifier: NSLocalizedString("ru_RU", comment: ""))
        date.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return date
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Трекеры", comment: "")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = NSLocalizedString("Поиск", comment: "")
        search.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        search.backgroundColor = UIColor(named: "SearchFieldSet")
        search.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        collection.backgroundColor = UIColor(named: "BackgroundSet")
        return collection
    }()
    
    private let mainTrackersViewImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrackersDefaultLogo")
        return image
    }()
    
    private let mainTrackersViewImageLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Что будем отслеживать?", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitle(NSLocalizedString("Фильтры", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(switchToFilterViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.dismiss(animated: true)
        
        searchField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        reloadMainScreen()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        analyticsService.report(event: Events.open, screen: "Main", item: Items.noItem)
        
        self.trackersViewControllerObserver = NotificationCenter.default.addObserver(
            forName: NotificationNames.coreDataChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.reloadMainScreen()
        }
        
        viewInit()
        trackerCategoryFixStore.fetchCurrentTrackerCategoryFixData()
    }
    
    deinit {
        trackersViewControllerObserver = nil
        analyticsService.report(event: Events.close, screen: "Main", item: Items.noItem)
    }
    
    // MARK: - Private Methods
    private func reloadMainScreen() {
        if !currentTrackerDataArray.isEmpty {
            filterButton.isHidden = false
            addSubviewsWithCollection()
            makeConstraintsWithCollection()
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(TrackerCellView.self, forCellWithReuseIdentifier: "cell")
            collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        } else {
            addSubviewsDefault()
            makeConstraintsDefault()
            filterButton.isHidden = true
        }
        collectionView.reloadData()
    }
    
    private func viewInit() {
        if storage.trackerViewStatus == 0 {
            allTrackersFilter()
        }
        
        if storage.trackerViewStatus == 1 {
            allTrackersFilter()
        }
        
        if storage.trackerViewStatus == 3 {
            completeTrackersFilter()
        }
        
        if storage.trackerViewStatus == 4 {
            incompleteTrackersFilter()
        }
    }
    
    private func dateChecker(date: Date) {
        let calendar = Calendar.current
        var currentTrackersIndexes = [Int]()
        
        currentTrackerData = trackerCategoryStore.fetchCurrentTrackerCategoryData(calendar: calendar, sender: date)
            
        for (index, item) in currentTrackerData.enumerated() {
            if item.categoryName == "Закрепленные" {
                currentTrackerData.insert(item, at: 0)
                currentTrackerData.remove(at: index + 1)
                break
            }
        }
                
        currentTrackersIndexes = trackerStore.fetchCurrentIndexes(calendar: calendar, sender: date)
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
            filterButton
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
            //            datePicker.widthAnchor.constraint(equalToConstant: 77),
            
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
            mainTrackersViewImageLabel.trailingAnchor.constraint(equalTo: mainTrackersViewImage.trailingAnchor, constant: 132),
            
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
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 693),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func placeHolder() {
        if currentTrackerData.isEmpty && !trackerStore.fetchCurrentIndexes(calendar: Calendar.current, sender: datePicker.date).isEmpty {
            collectionView.isHidden = true
            mainTrackersViewImage.image = UIImage(named: "Search placeholder")
            mainTrackersViewImageLabel.text = "Ничего не найдено"
        }
        
        if currentTrackerData.isEmpty && trackerStore.fetchCurrentIndexes(calendar: Calendar.current, sender: datePicker.date).isEmpty {
            collectionView.isHidden = true
            filterButton.isHidden = true
            mainTrackersViewImage.image = UIImage(named: "TrackersDefaultLogo")
            mainTrackersViewImageLabel.text = NSLocalizedString("Что будем отслеживать?", comment: "")
            
        }
        
        if !currentTrackerData.isEmpty {
            collectionView.isHidden = false
            filterButton.isHidden = false
            //            mainTrackersViewImage.image = UIImage(named: "TrackersDefaultLogo")
            //            mainTrackersViewImageLabel.text = NSLocalizedString("Что будем отслеживать?", comment: "")
        }
        collectionView.reloadData()
    }
    
    private func cellForFix(indexPath: IndexPath) {
        var trackerForFix = [TrackerCategory]()
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView
        trackerForFix = trackerStore.fetchSelectedTracker(trackerId: cell?.id ?? 1)
        trackerCategoryFixStore.trackerAndCategoryFixCreater(trackerCategoryName: trackerForFix[0].categoryName,
                                                             tracker: trackerForFix[0].trackers[0])
        print("трекер перемещен в фикс \(trackerForFix)")
        trackerStore.deleteSelectedTracker(trackerId: cell?.id ?? 1)
        
        trackerCategoryStore.trackerAndCategoryCreater(trackerCategoryName: "Закрепленные",
                                                       tracker: trackerForFix[0].trackers[0])

        dateChecker(date: datePicker.date)

        collectionView.reloadData()
    }
    
    private func cellForUnfix(indexPath: IndexPath) {
        var trackerForUnFix = [TrackerCategory]()
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView
        trackerForUnFix = trackerFixStore.fetchSelectedFixTracker(trackerId: cell?.id ?? 1)

        trackerCategoryStore.trackerAndCategoryCreater(trackerCategoryName: trackerForUnFix[0].categoryName,
                                                             tracker: trackerForUnFix[0].trackers[0])
        print("трекер запрошен из фикс \(trackerForUnFix)")
        
        trackerStore.deleteSelectedTracker(trackerId: cell?.id ?? 1)
        trackerFixStore.deleteSelectedFixTracker(trackerId: cell?.id ?? 1)
                
        dateChecker(date: datePicker.date)
        collectionView.reloadData()
    }
    
    private func cellForDelete(indexPath: IndexPath) {
//        var trackerForFix = [TrackerCategory]()
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView
//        trackerForFix = trackerStore.fetchSelectedTracker(trackerId: cell?.id ?? 1)
        trackerStore.deleteSelectedTracker(trackerId: cell?.id ?? 1)

        dateChecker(date: datePicker.date)

        collectionView.reloadData()
    }

    private func editingTracker(cellId: Int64) {
        let habitCreaterViewController = HabitCreaterViewController()
        let trackerNavigationController = UINavigationController(rootViewController: habitCreaterViewController)
        habitCreaterViewController.label.text = "Редактирование привычки"
        habitCreaterViewController.trackerId = cellId
        
        var cellData = [TrackerCategory]()
        
        cellData = trackerStore.fetchSelectedTracker(trackerId: cellId)
        
        habitCreaterViewController.trackerCategoryName = "123"
//        cellData[0].categoryName
//        print("\(cellData[0].categoryName)")
        habitCreaterViewController.trackerNameTextField.text = cellData[0].trackers[0].trackerName
        habitCreaterViewController.daysOfWeekShortArray = habitCreaterViewController.dateToDaysOfWeekShortConverter(dates: cellData[0].trackers[0].trackerDate)
        habitCreaterViewController.createButton.setTitle(NSLocalizedString("Сохранить", comment: ""), for: .normal)
        
        self.present(trackerNavigationController, animated: true)
    }
    
    // MARK: - Objc Methods
    @objc private func switchToTrackerChoiceViewController() {
        analyticsService.report(event: Events.click, screen: "Main", item: Items.addTrack)
        let trackerChoiceViewController = TrackerChoiceViewController()
        trackerChoiceViewController.delegate = self
        let trackerNavigationController = UINavigationController(rootViewController: trackerChoiceViewController)
        present(trackerNavigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewInit()
    }
    
    @objc private func searchTextDidChange(_ searchField: UISearchTextField) {
        var filteredTrackerDataArray: [TrackerCategory] = []
        filteredTrackerDataArray = currentTrackerData
        currentTrackerData.removeAll()
        
        if let searchText = searchField.text, !searchText.isEmpty {
            collectionView.isHidden = false
            var arr = [Tracker]()
            for i in filteredTrackerDataArray {
                arr = i.trackers.filter {
                    $0.trackerName.lowercased().contains(searchText.lowercased())
                }
                if !arr.isEmpty {
                    currentTrackerData.append(TrackerCategory(categoryName: i.categoryName, trackers: arr))
                }
            }
        } else {
            viewInit()
        }
        
        placeHolder()
    }
    
    @objc private func switchToFilterViewController() {
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        let trackerNavigationController = UINavigationController(rootViewController: filterViewController)
        present(trackerNavigationController, animated: true)
    }
}

// MARK: - extension TrackersViewController
extension TrackersViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        currentTrackerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return currentTrackerData[section].trackers.count
    }
    
    // cell setup
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCellView else { return TrackerCellView()}
        
        let cellData = currentTrackerData[indexPath.section]
        cell.titleLabel.text = cellData.trackers[indexPath.row].trackerName
        cell.emojiView.text = cellData.trackers[indexPath.row].trackerEmoji
        cell.cardView.backgroundColor = Constants.colorsForCell[Int(cellData.trackers[indexPath.row].trackerColor)]
        cell.checkButton.backgroundColor = Constants.colorsForCell[Int(cellData.trackers[indexPath.row].trackerColor)]
        cell.layer.cornerRadius = 16
        
        cell.id = cellData.trackers[indexPath.row].id
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
        let cellData = currentTrackerData[indexPath.section]
        view?.headerLabel.text = cellData.categoryName // ToDo: разные хэдеры для разного набора ячеек
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
        
        let paddingWidth: CGFloat = 16 + 16 + (cellsPerRow - 1) * cellSpacing
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
        UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    // context menu setup
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        let indexPath = indexPaths[0]
        var contextMenu = UIContextMenuConfiguration()
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView
        let trackerCategoryName = trackerStore.fetchSelectedTracker(trackerId: cell?.id ?? 1)
        
        if trackerCategoryName[0].categoryName != "Закрепленные" {
            
            contextMenu = UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                                      
                    UIAction(title: "Закрепить") { [weak self] _ in
                        self?.cellForFix(indexPath: indexPath)
                    },
                    
                    UIAction(title: "Редактировать") { [weak self] _ in
                        
                        self?.editingTracker(cellId: cell?.id ?? 1)
                        
                    },
                    
                    UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                        
                        let alert = UIAlertController(title: "Уверены что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
                        self?.present(alert, animated: true)
                        
                        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
                            self?.cellForDelete(indexPath: indexPath)
                            alert.dismiss(animated: false)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { action in
                            alert.dismiss(animated: false)
                        }))
                    }
                ])
            })
        } else {
            
            contextMenu = UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                    
                    UIAction(title: "Открепить") { [weak self] _ in
                        self?.cellForUnfix(indexPath: indexPath)
                    },
                    
                    UIAction(title: "Редактировать") { [weak self] _ in
                        self?.editingTracker(cellId: cell?.id ?? 1)

                    },
                    
                    UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                        let alert = UIAlertController(title: "Уверены что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
                        self?.present(alert, animated: true)
                        
                        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
                            self?.cellForDelete(indexPath: indexPath)
                            alert.dismiss(animated: false)
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { action in
                            alert.dismiss(animated: false)
                        }))
                    },
                ])
            })

        }
        return contextMenu
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
//        guard let identifier = configuration.identifier as? IndexPath else { return nil }
        let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
//        parameters.visiblePath = UIBezierPath(rect: cell?.cardView.bounds ?? CGRect())
        parameters.visiblePath = UIBezierPath(roundedRect: cell?.cardView.bounds ?? CGRect(), cornerRadius: 16)
        let preview = UITargetedPreview(view: cell ?? TrackerCellView(), parameters: parameters)
        return preview
    }
}

extension TrackersViewController: TrackerSender {
    func trackersViewControllerReloader() {
        viewWillAppear(true)
    }
}

extension TrackersViewController: FilterProtocol {
    func allTrackersFilter() {
        dateChecker(date: datePicker.date)
        storage.trackerViewStatus = 1
        placeHolder()
    }
    
    func trackersForTodayFilter() {
        datePicker.date = Date()
        dateChecker(date: datePicker.date)
        //        storage.trackerViewStatus = 2
        placeHolder()
    }
    
    func completeTrackersFilter() {
        dateChecker(date: datePicker.date)
        
        var filteredTrackerDataArray: [TrackerCategory] = []
        filteredTrackerDataArray = currentTrackerData
        currentTrackerData.removeAll()
        
        for i in filteredTrackerDataArray {
            var arr = [Tracker]()
            for item in i.trackers {
                if trackerRecordStore.recordChecker(currentDate: datePicker.date, id: item.id) == true {
                    arr.append(Tracker(id: item.id,
                                       trackerName: item.trackerName,
                                       trackerColor: item.trackerColor,
                                       trackerEmoji: item.trackerEmoji,
                                       trackerDate: item.trackerDate))
                }
            }
            if !arr.isEmpty {
                currentTrackerData.append(TrackerCategory(categoryName: i.categoryName, trackers: arr))
            }
            arr.removeAll()
        }
        storage.trackerViewStatus = 3
        placeHolder()
    }
    
    func incompleteTrackersFilter() {
        dateChecker(date: datePicker.date)
        
        var filteredTrackerDataArray: [TrackerCategory] = []
        filteredTrackerDataArray = currentTrackerData
        currentTrackerData.removeAll()
        
        for i in filteredTrackerDataArray {
            var arr = [Tracker]()
            for item in i.trackers {
                if trackerRecordStore.recordChecker(currentDate: datePicker.date, id: item.id) == false {
                    arr.append(Tracker(id: item.id,
                                       trackerName: item.trackerName,
                                       trackerColor: item.trackerColor,
                                       trackerEmoji: item.trackerEmoji,
                                       trackerDate: item.trackerDate))
                }
            }
            if !arr.isEmpty {
                currentTrackerData.append(TrackerCategory(categoryName: i.categoryName, trackers: arr))
            }
            arr.removeAll()
        }
        storage.trackerViewStatus = 4
        placeHolder()
    }
}
