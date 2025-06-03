//
//  DailiForecastCell.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import UIKit

final class DailyForecastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DailyForecastCell"
    
    // MARK: - UI
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tempRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dayLabel, iconImageView, tempRangeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension DailyForecastCell {
    func configure(with day: ForecastDay) {
        dayLabel.text = day.dayName
        tempRangeLabel.text = "\(Int(day.day.mintempC))°/\(Int(day.day.maxtempC))°"
        
        let fullUrl = "https:\(day.day.condition.icon)"
        if let url = URL(string: fullUrl) {
            setImage(url: url)
        }
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorView.isHidden = hide
    }
}

// MARK: - Private Methods
private extension DailyForecastCell {
    func setupViews() {
        addSubviews()
        disableTranslation()
        setupConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
    }
    
    func disableTranslation() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dayLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func setImage(url: URL) {
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
}
