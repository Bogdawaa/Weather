//
//  NetworkErrors.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 28.05.2025.
//

enum NetworkError: Error {
    case badURL
    case decodingError
    case invalidResponse
    case serverError(statusCode: Int)
    case unknownError(Error)
}
