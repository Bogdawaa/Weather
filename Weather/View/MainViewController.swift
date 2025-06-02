//
//  ViewController.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - UI Elements
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Header elements
    private lazy var locationNameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var currentTemperatureLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 58, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    
    private lazy var conditionTextLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var extremumTemperaturesLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var headerContainer: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                locationNameLabel,
                currentTemperatureLabel,
                conditionTextLabel,
                extremumTemperaturesLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Content elements
    private lazy var hourForecastCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            HourlyForecastCell.self,
            forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier
        )
        collectionView.register(
            DailyForecastCell.self,
            forCellWithReuseIdentifier: DailyForecastCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.bouncesVertically = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Properties
    private var presenter: MainPresenter
    private var hourlyForecast: [HourForecast] = []
    private var dailyForecast: [ForecastDay] = []
    
    
    // MARK: - Init
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        hourForecastCollectionView.layer.cornerRadius = hourForecastCollectionView.frame.height / 20
    }
}

// MARK: - Public Methods
extension MainViewController {
    func updateViewData(with forecast: ForecastResponse) {
        self.locationNameLabel.text = forecast.location.name
        
        self.currentTemperatureLabel.text = String(format: "%.0f°C", forecast.current.tempC)
        
        self.conditionTextLabel.text = forecast.current.condition.text
        
        self.extremumTemperaturesLabel.text = String(
            format: "Макс.: %.0f°C, мин.: %.0f°C",
            forecast.forecast.forecastday[0].day.maxtempC,
            forecast.forecast.forecastday[0].day.mintempC
        )
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayHourlyForecast(_ hours: [HourForecast]) {
        hourlyForecast = hours
        hourForecastCollectionView.reloadData()
    }
    
    func displayDailyForecast(_ days: [ForecastDay]) {
        dailyForecast = days
        hourForecastCollectionView.reloadData()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .systemCyan
        disableConstraintsTranslation()
        addSubviews()
        setupConstraints()
    }
    
    func disableConstraintsTranslation() {
        [
            locationNameLabel,
            currentTemperatureLabel,
            conditionTextLabel,
            extremumTemperaturesLabel,
            headerContainer,
            hourForecastCollectionView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addSubviews() {
        headerContainer.addSubview(extremumTemperaturesLabel)
        view.addSubview(headerContainer)
        view.addSubview(hourForecastCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            hourForecastCollectionView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 20),
            hourForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hourForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hourForecastCollectionView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            if sectionIndex == 0 {
                // 0 - Почасовой прогноз
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(70),
                    heightDimension: .absolute(100)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 16,
                    bottom: 8,
                    trailing: 16
                )
                
                // background
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "section-background"
                )
                backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
                section.decorationItems = [backgroundDecoration]
                
                return section
            } else {
                // 1 - дневной прогноз
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(180)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(8)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 16,
                    bottom: 0,
                    trailing: 16
                )
                
                // background
                let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: "section-background"
                )
                backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(
                    top: 16,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
                section.decorationItems = [backgroundDecoration]
                
                return section
            }
        }
        
        layout.register(
            SectionBackgroundView.self,
            forDecorationViewOfKind: "section-background"
        )
        
        return layout
    }
}

// MARK: - Extension UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? hourlyForecast.count : dailyForecast.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourlyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? HourlyForecastCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: hourlyForecast[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? DailyForecastCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: dailyForecast[indexPath.item])
            return cell
        }
    }
}

