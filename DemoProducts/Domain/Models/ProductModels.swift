//
//  ProductModels.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import Foundation

struct ProductListResponse: Codable {
    let data: [Product]
    let pagination: Pagination
}

struct Product: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let description: String?
    let category: String?
    let brand: String?
    let stock: Int?
    let image: String?
    let specs: [String: SpecValue]?
    let rating: Rating?
}

struct Rating: Codable {
    let rate: Double?
    let count: Int?
}

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let nextPage: Int?
}

enum SpecValue: Codable, CustomStringConvertible {
    case string(String), bool(Bool), int(Int), double(Double)

    var description: String {
        switch self {
        case .string(let v): return v
        case .bool(let v): return v ? "Yes" : "No"
        case .int(let v): return "\(v)"
        case .double(let v): return "\(v)"
        }
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let v = try? c.decode(Int.self) {
            self = .int(v)
        } else if let v = try? c.decode(Double.self) {
            self = .double(v)
        } else if let v = try? c.decode(Bool.self) {
            self = .bool(v)
        } else {
            self = .string(try c.decode(String.self))
        }
    }
}

extension Product {
    var ratingText: String {
        let rate = rating?.rate ?? 0
        let count = rating?.count ?? 0
        return "\(AppConstants.UI.ratingPrefix) \(rate) (\(count))"
    }

    var ratingValue: Double {
        rating?.rate ?? 0
    }
}

extension Product {
    var specsList: [(title: String, value: String)] {
        specs?.sorted { $0.key < $1.key }.map { ($0.key.capitalized, $0.value.description) } ?? []
    }
}
