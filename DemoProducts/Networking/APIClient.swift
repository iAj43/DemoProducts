//
//  APIClient.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import Foundation

protocol APIClientProtocol {
    func fetchProducts(page: Int, limit: Int, category: String?) async throws -> ProductListResponse
}

final class APIClient: APIClientProtocol {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProducts(page: Int, limit: Int, category: String?) async throws -> ProductListResponse {

        guard var components = URLComponents(string: AppConstants.API.baseURL + AppConstants.API.productsPath) else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "limit", value: "\(limit)")
        ]

        if let category, !category.isEmpty {
            components.queryItems?.append(.init(name: "category", value: category))
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(ProductListResponse.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
