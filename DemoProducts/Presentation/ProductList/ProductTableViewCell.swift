//
//  ProductTableViewCell.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {

    // MARK: - UI elements
    static let reuseId = "ProductCell"
    private let productImageView = ProductImageView(frame: .zero)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let stack = UIStackView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.reset()
        titleLabel.text = nil
        descriptionLabel.text = nil
        categoryLabel.text = nil
        priceLabel.text = nil
        ratingLabel.text = nil
    }
}

// MARK: - Bind ViewModel
extension ProductTableViewCell {
    
    func configure(with viewModel: ProductCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        categoryLabel.text = viewModel.category
        priceLabel.text = viewModel.price
        ratingLabel.text = viewModel.ratingText
        ratingLabel.textColor = viewModel.ratingColor
        productImageView.load(from: viewModel.imageURL)
        accessibilityLabel = "\(viewModel.title), \(viewModel.price), \(viewModel.ratingText)"
    }
}

// MARK: - Setup UI
private extension ProductTableViewCell {

    func setupUI() {
        selectionStyle = .default
        accessibilityTraits = .button

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        
        descriptionLabel.font = .preferredFont(forTextStyle: .footnote)
        descriptionLabel.numberOfLines = 2
        
        categoryLabel.font = .preferredFont(forTextStyle: .footnote)
        categoryLabel.textColor = .secondaryLabel

        priceLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        ratingLabel.font = .preferredFont(forTextStyle: .footnote)

        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, descriptionLabel, categoryLabel, priceLabel, ratingLabel]
            .forEach(stack.addArrangedSubview)

        contentView.addSubview(productImageView)
        contentView.addSubview(stack)

        productImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),

            stack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
