//
//  ProductImageView.swift
//  DemoProducts
//
//  Created by IA on 19/01/26.
//

import UIKit

final class ProductImageView: UIImageView {

    private var imageTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        tintColor = .secondaryLabel
        image = UIImage(systemName: AppConstants.UI.defaultImageSystemName)
    }

    required init?(coder: NSCoder) { fatalError() }

    func reset() {
        imageTask?.cancel()
        imageTask = nil
        image = UIImage(systemName: AppConstants.UI.defaultImageSystemName)
    }

    func load(from url: URL?) {
        imageTask?.cancel()
        imageTask = nil

        guard let url else {
            image = UIImage(systemName: AppConstants.UI.defaultImageSystemName)
            return
        }

        imageTask = Task { [weak self] in
            guard let self else { return }
            let img = await ImageLoader.shared.loadImage(from: url)
            await MainActor.run {
                self.image = img ?? UIImage(systemName: AppConstants.UI.defaultImageSystemName)
            }
        }
    }
    
    deinit {
        imageTask?.cancel()
    }
}
