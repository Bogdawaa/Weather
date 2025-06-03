//
//  SectionBackgroundView.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import UIKit

class SectionBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white.withAlphaComponent(0.2)
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}

