//
//  APIError.swift
//  DemoProducts
//
//  Created by IA on 19/01/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}
