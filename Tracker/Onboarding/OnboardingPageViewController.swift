//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Кирилл Дробин on 22.01.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var onboardingImage: String
    private var onboardingTitle: String
    
    private lazy var onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var onboardingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialisers
    init(onboardingImage: String, onboardingTitle: String) {
        self.onboardingImage = onboardingImage
        self.onboardingTitle = onboardingTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingImageView.image = UIImage(named: onboardingImage)
        onboardingLabel.text = onboardingTitle
        
        addSubviews()
        makeConstraints()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [
            onboardingImageView,
            onboardingLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            onboardingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            onboardingLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
}
