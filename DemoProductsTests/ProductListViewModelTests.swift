//
//  ProductListViewModelTests.swift
//  DemoProducts
//
//  Created by IA on 20/01/26.
//

import XCTest
@testable import DemoProducts

@MainActor
final class ProductListViewModelTests: XCTestCase {

    private var useCase: MockFetchProductsUseCase!
    private var sut: ProductListViewModel!

    override func setUp() {
        super.setUp()
        useCase = MockFetchProductsUseCase()
        sut = ProductListViewModel(
            category: AppConstants.API.defaultCategory,
            useCase: useCase
        )
    }

    override func tearDown() {
        sut = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_loadNextPage_success_onInitialLoad_updatesProducts() async {
        let products = [Product.mock(id: 1), Product.mock(id: 2)]
        useCase.result = .success(.make(products: products, nextPage: 1))

        var states: [ProductListViewModel.State] = []
        sut.onStateChange = { states.append($0) }

        await sut.loadNextPage()

        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(useCase.receivedPages, [0])
        XCTAssertTrue(states.contains {
            if case .updated = $0 { return true }
            return false
        })
    }

    func test_pagination_appendsData() async {
        useCase.result = .success(.make(products: [.mock(id: 1)], nextPage: 1))
        await sut.loadNextPage()

        useCase.result = .success(.make(products: [.mock(id: 2)], nextPage: nil))
        await sut.loadNextPage()

        XCTAssertEqual(sut.products.map(\.id), [1, 2])
        XCTAssertEqual(useCase.receivedPages, [0, 1])
    }

    func test_emptyResponse_emitsEmptyState() async {
        useCase.result = .success(.make(products: [], nextPage: nil))

        var receivedState: ProductListViewModel.State?
        sut.onStateChange = { receivedState = $0 }

        await sut.loadNextPage()

        if case .empty = receivedState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected empty state")
        }
    }

    func test_error_emitsErrorState() async {
        useCase.result = .failure(APIError.invalidResponse)

        var receivedState: ProductListViewModel.State?
        sut.onStateChange = { receivedState = $0 }

        await sut.loadNextPage()

        if case .error(let message) = receivedState {
            XCTAssertEqual(message, AppConstants.Messages.loadFailed)
        } else {
            XCTFail("Expected error state")
        }
    }
}

private extension Product {

    static func mock(id: Int) -> Product {
        Product(
            id: id,
            title: "Product \(id)",
            price: 100,
            description: "Desc",
            category: "electronics",
            brand: "Brand",
            stock: 10,
            image: nil,
            specs: nil,
            rating: nil
        )
    }
}

private extension ProductListResponse {

    static func make(
        products: [Product],
        nextPage: Int?
    ) -> ProductListResponse {
        ProductListResponse(
            data: products,
            pagination: Pagination(
                page: 0,
                limit: 10,
                total: products.count,
                nextPage: nextPage
            )
        )
    }
}
