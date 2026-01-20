//
//  FetchProductsUseCase.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import Foundation

protocol FetchProductsUseCaseProtocol {
    func execute(page: Int, limit: Int, category: String?) async throws -> ProductListResponse
}

final class FetchProductsUseCase: FetchProductsUseCaseProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func execute(page: Int, limit: Int, category: String?) async throws -> ProductListResponse {
        try await apiClient.fetchProducts(page: page, limit: limit, category: category)
    }
}
