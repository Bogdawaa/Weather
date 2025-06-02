//
//  HourForecastCollectionViewCell.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 30.05.2025.
//

import UIKit

class HourForecastCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HourForecastCollectionViewCell"
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with hour: HourForecast) {
        
        timeLabel.text = String(formateTime(time: hour.time))
        
        let fullUrl = "https:\(hour.condition.icon)"
        if let url = URL(string: fullUrl) {
            setImage(url: url)
        }
        temperatureLabel.text = String(format: "%.0f°C", hour.tempC)
    }
   
    // MARK: - Private Methods
    private func formateTime(time: String) -> String {
        guard let date = DateFormatter.hourFormatter.date(from: time) else {
            return String(time.split(separator: " ").last ?? "")
        }
        
        DateFormatter.hourFormatter.dateFormat = "h"
        return DateFormatter.hourFormatter.string(from: date)
    }
    
    private func setImage(url: URL) {
        Task {
            do {
                let image = try await iconImageView.loadImage(for: url)
                self.iconImageView.image = image
            } catch {
                print(error.localizedDescription)
                self.iconImageView.image = nil
            }
        }
    }
    
    private func addSubviews() {
        [
            timeLabel,
            iconImageView,
            temperatureLabel,
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [stackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

