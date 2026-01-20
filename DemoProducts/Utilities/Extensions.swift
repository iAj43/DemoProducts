//
//  Extensions.swift
//  DemoProducts
//
//  Created by IA on 19/01/26.
//

import UIKit

// MARK: - UIView
extension UIView {
    static func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }
}
