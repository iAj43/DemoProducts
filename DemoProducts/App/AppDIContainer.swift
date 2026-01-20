//
//  AppDIContainer.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

final class AppDIContainer {

    lazy var apiClient: APIClientProtocol = APIClient()
    lazy var fetchProductsUseCase: FetchProductsUseCaseProtocol = FetchProductsUseCase(apiClient: apiClient)

    @MainActor
    func makeProductListViewController() -> ProductListViewController {
        let productListViewModel = ProductListViewModel(
            category: AppConstants.API.defaultCategory,
            useCase: fetchProductsUseCase
        )
        return ProductListViewController(viewModel: productListViewModel)
    }
}
