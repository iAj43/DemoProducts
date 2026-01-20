//
//  AppConstants.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import Foundation

enum AppConstants {

    enum API {
        static let baseURL = "https://fakeapi.net"
        static let productsPath = "/products"
        static let pageSize = 10
        static let defaultCategory = "electronics"
    }

    enum UI {
        static let productsTitle = "Electronics"
        static let detailsTitle = "Details"
        static let defaultImageSystemName = "photo"
        static let errorTitle = "Error"
        static let retryTitle = "Retry"
        static let ratingPrefix = "★"
        static let priceFormat = "$%.2f"
    }

    enum Messages {
        static let noData = "No products found"
        static let loadFailed = "Unable to load products"
        static let unnamedProduct = "Unnamed Product"
        static let genericBrand = "Brand: Generic"
        static let brandPrefix = "Brand:"
        static let unnamedCategory = "Unnamed Category"
        static let descriptionTitle = "Description"
        static let noDescription = "No description available"
        static let specsTitle = "Specifications"
        static let outOfStock = "Out of stock"
        static let inStockPrefix = "In stock:"
    }
}
