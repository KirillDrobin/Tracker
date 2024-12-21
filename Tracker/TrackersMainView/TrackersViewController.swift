//
//  TrackersViewcontroller.swift
//  Tracker
//
//  Created by Кирилл Дробин on 06.10.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    static var shared = TrackersViewController()
    // MARK: - Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    let trackerStorage = TrackerStorage.shared
    var currentTrackerDataArray = [Tracker]()
    
    // MARK: - Private Properties
    private var trackersViewControllerObserver: NSObjectProtocol?
    private let trackerRecordStorage = TrackerRecordStorage.shared

    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Add tracker"), for: .normal)
        button.addTarget(self, action: #selector(switchToTrackerChoiceViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.locale = Locale(identifier: "ru_RU")
        date.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .allEvents)
        return date
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var searchField: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        search.textColor = .gray
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private lazy var mainTrackersViewImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrackersDefaultLogo")
        return image
    }()
    
    private lazy var mainTrackersViewImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadMainScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        trackersViewControllerObserver = NotificationCenter.default
            .addObserver(forName: .valueChange,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
            guard let self = self else { return }
                self.reloadMainScreen()
        }
        dateChecker(datePicker)
        print("3 will appear")
    }
    
    // MARK: - Private Methods
    private func reloadMainScreen() {
        if trackerStorage.currentTrackersIndexes.isEmpty == false {
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
        let senderDate = sender.date
        trackerStorage.currentTrackersIndexes.removeAll()
        let calendar = Calendar.current

        for (index, item) in trackerStorage.tracker.enumerated() {
            for i in item.trackerDate {
                var cellDatecomponents = DateComponents()
                var senderDatecomponets = DateComponents()
                
                senderDatecomponets.weekday = calendar.dateComponents([.weekday], from: senderDate).weekday
                cellDatecomponents.weekday = calendar.dateComponents([.weekday], from: i).weekday
                if cellDatecomponents == senderDatecomponets && item.id <= 10000 {
                    trackerStorage.currentTrackersIndexes.append(index)
                    print("индексы записались для привычки \(trackerStorage.currentTrackersIndexes)")
                } else {
                    print("индексы не записались")
                }
            }
            
            for i in item.trackerDate {
                var cellDatecomponents = DateComponents()
                var senderDatecomponets = DateComponents()
                cellDatecomponents.day = calendar.dateComponents([.day], from: i).day
                cellDatecomponents.month = calendar.dateComponents([.month], from: i).month
                cellDatecomponents.year = calendar.dateComponents([.year], from: i).year
                
                senderDatecomponets.day = calendar.dateComponents([.day], from: senderDate).day
                senderDatecomponets.month = calendar.dateComponents([.month], from: senderDate).month
                senderDatecomponets.year = calendar.dateComponents([.year], from: senderDate).year
                
                print("дата из массива \(cellDatecomponents)")
                print("текущая дата \(senderDatecomponets)")
                
                if cellDatecomponents == senderDatecomponets && item.id > 10000 {
                    trackerStorage.currentTrackersIndexes.append(index)
                    print("индексы записались для нерегулярки \(trackerStorage.currentTrackersIndexes)")
                } else {
                    print("индексы не записались")
                }
            }
            
            NotificationCenter.default.post(name:.valueChange, object: nil)
        }
    }
  
    private func addSubviewsDefault() {
        [
            addTrackerButton,
            datePicker,
            label,
            searchField,
            mainTrackersViewImage,
            mainTrackersViewImageLabel
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
        }
    }
    
    private func addSubviewsWithCollection() {
        [
            addTrackerButton,
            datePicker,
            label,
            searchField,
            collectionView,
        ].forEach { [weak self] in
            $0.translatesAutoresizingMaskIntoConstraints = false
            self?.view.addSubview($0)
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
        let trackerNavigationController = UINavigationController(rootViewController: trackerChoiceViewController)
        present(trackerNavigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        dateChecker(sender)
        print("2")
    }
}

// MARK: - extension TrackersViewController
extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerStorage.currentTrackersIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCellView else { return TrackerCellView()}
        print("1")
        currentTrackerDataArray.removeAll()
        for i in trackerStorage.currentTrackersIndexes{
            currentTrackerDataArray.append(trackerStorage.tracker[i])
        }
        
        let currentDate = Date()

        if datePicker.date > currentDate {
            cell.checkButton.isEnabled = false
        } else {
            cell.checkButton.isEnabled = true
        }
        
        print("текущие трекеры: \(currentTrackerDataArray)")
        cell.titleLabel.text = currentTrackerDataArray[indexPath.row].trackerName
        cell.emojiView.text = currentTrackerDataArray[indexPath.row].trackerEmoji
        cell.cardView.backgroundColor = currentTrackerDataArray[indexPath.row].trackerColor

        cell.id = currentTrackerDataArray[indexPath.row].id
        cell.datePickerDate = datePicker.date
        cell.cellViewInit()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerHeaderView
        if trackerStorage.currentTrackersIndexes.isEmpty == false {
            view.headerLabel.text = "Важное"
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width - 28,
                                                         height: 18),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 148.0
        let cellsPerRow: CGFloat = 2.0
        let cellSpacing: CGFloat = 9.0
        
        let paddingWidth: CGFloat = (cellsPerRow - 1) * cellSpacing
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / CGFloat(cellsPerRow)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
    }
}
