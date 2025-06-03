//
//  ViewController.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

import UIKit

final class MainViewController: UIViewController {

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
        label.numberOfLines = 0
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
        collectionView.register(
            WeatherDefaultCell.self,
            forCellWithReuseIdentifier: WeatherDefaultCell.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.bouncesVertically = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Properties
    private var presenter: MainPresenter
    private var hourlyForecast: [HourForecast] = []
    private var dailyForecast: [ForecastDay] = []
    
    private var uvAndPressureItems: [WeatherItem] = []
    private var precipitationItems: [WeatherItem] = []
    private var windItems: [WeatherItem] = []
    
    
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
}

// MARK: - Public Methods
extension MainViewController: MainViewProtocol {
    
    // Display
    func displayAdditionalSections(
        uvAndPressure: [WeatherItem],
        precipitation: [WeatherItem],
        wind: [WeatherItem]
    ) {
        self.uvAndPressureItems = uvAndPressure
        self.precipitationItems = precipitation
        self.windItems = wind
        hourForecastCollectionView.reloadData()
    }
    
    func displayCurrentDayForecast(_ forecast: ForecastResponse) {
        DispatchQueue.main.async {
            self.locationNameLabel.text = forecast.location.name
            self.currentTemperatureLabel.text = String(format: "%.0f°C", forecast.current.tempC)
            self.conditionTextLabel.text = forecast.current.condition.text
            self.extremumTemperaturesLabel.text = String(
                format: "\("max".localized.capitalized).: %.0f°C, \("min".localized).: %.0f°C",
                forecast.forecast.forecastday[0].day.maxtempC,
                forecast.forecast.forecastday[0].day.mintempC
            )
        }
    }
    
    func displayHourlyForecast(_ hours: [HourForecast]) {
        hourlyForecast = hours
        
        DispatchQueue.main.async {
            self.hourForecastCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func displayDailyForecast(_ days: [ForecastDay]) {
        dailyForecast = days
        
        DispatchQueue.main.async {
            self.hourForecastCollectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    
    
    // Alert
    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // State
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
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
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            hourForecastCollectionView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 20),
            hourForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hourForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hourForecastCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                return self.createHourlySection()
            case 1:
                return self.createDailySection()
            case 2,3,4:
                return self.createDefaultSection()
            default:
                return nil
            }
        }
        
        layout.register(
            SectionBackgroundView.self,
            forDecorationViewOfKind: "section-background"
        )
        
        return layout
    }
    
    func createDailySection() -> NSCollectionLayoutSection {
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
    
    func createHourlySection() -> NSCollectionLayoutSection {
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
    }
    
    func createDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12)
        
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

// MARK: - Extension UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return hourlyForecast.count
        case 1: return dailyForecast.count
        case 2: return uvAndPressureItems.count
        case 3: return precipitationItems.count
        case 4: return windItems.count
        default: return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourlyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? HourlyForecastCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: hourlyForecast[indexPath.item])
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyForecastCell.reuseIdentifier,
                for: indexPath
            ) as? DailyForecastCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: dailyForecast[indexPath.item])
            return cell
            
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDefaultCell.reuseIdentifier, for: indexPath) as? WeatherDefaultCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: uvAndPressureItems[indexPath.item])
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDefaultCell.reuseIdentifier, for: indexPath) as? WeatherDefaultCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: precipitationItems[indexPath.item])
            return cell
            
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDefaultCell.reuseIdentifier, for: indexPath) as? WeatherDefaultCell else { return UICollectionViewCell()
            }
            cell.configure(with: windItems[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

