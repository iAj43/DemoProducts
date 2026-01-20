//
//  MockFetchProductsUseCase.swift
//  DemoProducts
//
//  Created by IA on 20/01/26.
//

import Foundation
@testable import DemoProducts

final class MockFetchProductsUseCase: FetchProductsUseCaseProtocol {

    var result: Result<ProductListResponse, Error> = .failure(APIError.invalidResponse)
    private(set) var receivedPages: [Int] = []

    func execute(page: Int, limit: Int, category: String?) async throws -> ProductListResponse {
        receivedPages.append(page)

        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
