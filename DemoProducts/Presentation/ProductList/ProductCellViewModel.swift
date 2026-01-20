//
//  ProductCellViewModel.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

struct ProductCellViewModel {

    let title: String
    let description: String
    let category: String
    let price: String
    let ratingText: String
    let ratingColor: UIColor
    let imageURL: URL?

    init(product: Product) {
        title = product.title ?? AppConstants.Messages.unnamedProduct
        description = product.description ?? AppConstants.Messages.noDescription
        category = product.category?.capitalized ?? AppConstants.Messages.unnamedCategory
        price = String(format: AppConstants.UI.priceFormat, product.price ?? 0)
        ratingText = product.ratingText
        ratingColor = product.ratingValue >= 4.0 ? .systemGreen : .systemOrange
        imageURL = product.image.flatMap(URL.init)
    }
}
