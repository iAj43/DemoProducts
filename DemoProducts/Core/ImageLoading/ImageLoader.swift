//
//  ImageLoader.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

actor ImageLoader {

    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL) async -> UIImage? {

        let cacheKey = url as NSURL

        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard
                let http = response as? HTTPURLResponse,
                (200...299).contains(http.statusCode),
                let mimeType = http.mimeType,
                mimeType.hasPrefix("image"),
                let image = UIImage(data: data)
            else {
                return nil
            }

            cache.setObject(image, forKey: cacheKey)
            return image

        } catch {
            return nil
        }
    }
}
