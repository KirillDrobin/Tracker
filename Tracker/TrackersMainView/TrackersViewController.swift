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
    private let storage = Storage.shared
    
    // MARK: - Private Properties
    private var trackersViewControllerObserver: NSObjectProtocol?
    private var currentDate = Date()
    //    private var currentTrackersIndexes = [Int]()
    private var currentTrackerDataArray = [Tracker]()
    
    private var currentTrackerData = [TrackerCategory]()
    
    private var currentCategories = [TrackerCategory]()
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
        //        filteredTrackerDataArray = currentTrackerDataArray
        //        print("фильтр треки \(filteredTrackerDataArray)")
        
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.dismiss(animated: true)
        
        searchField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        reloadMainScreen()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        filteredTrackerDataArray = currentTrackerDataArray
        //        print("фильтр треки \(filteredTrackerDataArray)")
        
        analyticsService.report(event: Events.open, screen: "Main", item: Items.noItem)
        

        
        self.trackersViewControllerObserver = NotificationCenter.default.addObserver(
            forName: NotificationNames.coreDataChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.reloadMainScreen()
        }
        //        dateChecker(date: datePicker.date)
        viewInit()
    }
    
    deinit {
        trackersViewControllerObserver = nil
        analyticsService.report(event: Events.close, screen: "Main", item: Items.noItem)
    }
    
    // MARK: - Private Methods
    private func reloadMainScreen() {
        if !currentTrackerDataArray.isEmpty /*storage.filteredTrackersData.isEmpty*/ {
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
        print("no filter")
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
    //        currentDate = sender.date
    //        currentTrackersIndexes.removeAll()
    let calendar = Calendar.current
    var currentTrackersIndexes = [Int]()
    
    currentTrackerData = trackerCategoryStore.fetchCurrentTrackerCategoryData(calendar: calendar, sender: date)
    
    currentTrackersIndexes = trackerStore.fetchCurrentIndexes(calendar: calendar, sender: date)
    currentTrackerDataArray = trackerStore.fetchCurrentTrackersData(currentTrackersIndexes: currentTrackersIndexes)
    currentCategories = trackerCategoryStore.fetchCategories()
    
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
//    var filteredTrackerDataArray: [Tracker] = []
//    filteredTrackerDataArray = currentTrackerDataArray
//    
//    if let searchText = searchField.text, !searchText.isEmpty {
//        collectionView.isHidden = false
//        currentTrackerDataArray = filteredTrackerDataArray.filter {
//            $0.trackerName.lowercased().contains(searchText.lowercased())
//        }
    
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
            print("поиск: \(currentTrackerData)")
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
//        return currentTrackerDataArray.count
        let numberOfItems = currentTrackerData[section]
        return numberOfItems.trackers.count
    }
    
    // cell setup
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCellView else { return TrackerCellView()}
        
//        cell.titleLabel.text = currentTrackerDataArray[indexPath.row].trackerName
//        cell.emojiView.text = currentTrackerDataArray[indexPath.row].trackerEmoji
//        cell.cardView.backgroundColor = Constants.colorsForCell[Int(currentTrackerDataArray[indexPath.row].trackerColor)]
//        cell.checkButton.backgroundColor = Constants.colorsForCell[Int(currentTrackerDataArray[indexPath.row].trackerColor)]
//        cell.layer.cornerRadius = 16
//        
//        cell.id = currentTrackerDataArray[indexPath.row].id
        
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
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Закрепить") { [weak self] _ in
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    
                },
                
                UIAction(title: "Удалить") { [weak self] _ in
                    
                },
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCellView
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(rect: cell?.cardView.bounds ?? CGRect())
        
        return UITargetedPreview(view: cell?.cardView ?? UIView(), parameters: parameters)
    }
    
    
    //    func collectionView (_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    //        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
    //        // Get the cell for the index of the model
    //        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCellView else { return nil }
    //
    //        // Set parameters to a circular mask and clear background
    //        let parameters = UIPreviewParameters()
    //        parameters.backgroundColor = .clear
    //        parameters.visiblePath = UIBezierPath(ovalIn: cell.cardView.bounds)
    //
    //        return UITargetedPreview(view: cell.cardView, parameters: parameters)
    //    }
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
        storage.trackerViewStatus = 2
        placeHolder()
    }
    
    func completeTrackersFilter() {
        dateChecker(date: datePicker.date)
        
        var filteredTrackerDataArray: [Tracker] = []
        filteredTrackerDataArray = currentTrackerDataArray
        currentTrackerDataArray.removeAll()
        
        for i in filteredTrackerDataArray {
            if trackerRecordStore.recordChecker(currentDate: datePicker.date, id: i.id) == true {
                currentTrackerDataArray.append(i)
            }
        }
        print("отфильтрованные выполненные трекеры: \(currentTrackerDataArray)")
        storage.trackerViewStatus = 3
        placeHolder()
    }
    
    func incompleteTrackersFilter() {
        dateChecker(date: datePicker.date)
        
        var filteredTrackerDataArray: [Tracker] = []
        filteredTrackerDataArray = currentTrackerDataArray
        currentTrackerDataArray.removeAll()
        
        for i in filteredTrackerDataArray {
            if trackerRecordStore.recordChecker(currentDate: datePicker.date, id: i.id) == false {
                currentTrackerDataArray.append(i)
            }
        }
        print("отфильтрованные невыполненные трекеры: \(currentTrackerDataArray)")
        storage.trackerViewStatus = 4
        placeHolder()
    }
}
