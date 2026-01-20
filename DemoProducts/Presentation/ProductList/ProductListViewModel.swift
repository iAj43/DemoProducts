//
//  ProductListViewModel.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import Foundation

@MainActor
final class ProductListViewModel {

    enum State {
        case initialLoading
        case paging
        case updated
        case empty
        case error(String)
    }

    private let useCase: FetchProductsUseCaseProtocol
    private let category: String?

    private var productsInternal: [Product] = []
    var products: [Product] { productsInternal }

    private var isLoading = false
    private var nextPage: Int? = 0
    private(set) var lastFetchedCount = 0

    var onStateChange: (@MainActor (State) -> Void)?

    init(category: String?, useCase: FetchProductsUseCaseProtocol) {
        self.category = category
        self.useCase = useCase
    }

    func loadNextPage() async {
        guard !isLoading, let page = nextPage else { return }
        isLoading = true
        defer { isLoading = false }

        productsInternal.isEmpty
            ? onStateChange?(.initialLoading)
            : onStateChange?(.paging)

        do {
            let response = try await useCase.execute(
                page: page,
                limit: AppConstants.API.pageSize,
                category: category
            )

            lastFetchedCount = response.data.count
            productsInternal.append(contentsOf: response.data)
            nextPage = response.data.isEmpty ? nil : response.pagination.nextPage

            productsInternal.isEmpty
                ? onStateChange?(.empty)
                : onStateChange?(.updated)

        } catch {
            onStateChange?(.error(AppConstants.Messages.loadFailed))
        }
    }
}
