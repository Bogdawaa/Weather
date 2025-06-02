//
//  UIImageView+Extension.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import UIKit

extension UIImageView {
    func loadImage(for url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
}
