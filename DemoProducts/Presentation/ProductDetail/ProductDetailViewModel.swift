//
//  ProductDetailViewModel.swift
//  DemoProducts
//
//  Created by IA on 19/01/26.
//

import UIKit

struct ProductDetailViewModel { 
    
    let title: String
    let priceText: String
    let ratingText: String
    let ratingColor: UIColor
    let stockText: String
    let brand: String
    let category: String
    let descriptionText: String
    let specs: [(title: String, value: String)]
    let imageURL: URL?
    
    init(product: Product) {
       
        title = product.title ?? AppConstants.Messages.unnamedProduct
        priceText = String(format: AppConstants.UI.priceFormat, product.price ?? 0)
        ratingText = product.ratingText
        ratingColor = product.ratingValue >= 4.0 ? .systemGreen : .systemOrange
        let stock = product.stock ?? 0
        stockText = stock > 0
            ? "\(AppConstants.Messages.inStockPrefix) \(stock)"
            : AppConstants.Messages.outOfStock
        brand = ProductDetailViewModel.makeBrand(from: product.brand)
        category = product.category?.capitalized ?? ""

        descriptionText = product.description ?? AppConstants.Messages.noDescription
        specs = product.specsList
        imageURL = product.image.flatMap(URL.init)
    }
}

// MARK: - formatting helper
private extension ProductDetailViewModel {
    
    static func makeBrand(from brand: String?) -> String {
        guard let brand, !brand.isEmpty else {
            return AppConstants.Messages.genericBrand
        }
        return "\(AppConstants.Messages.brandPrefix) \(brand)"
    }
}
