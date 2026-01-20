//
//  ProductDetailViewController.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

final class ProductDetailViewController: UIViewController {

    // MARK: - UI elements
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let imageContainer = UIView()
    private let productImageView = ProductImageView(frame: .zero)

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let stockLabel = UILabel()
    private let categoryLabel = UILabel()
    private let brandLabel = UILabel()

    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let specsTitleLabel = UILabel()
    private let specsStack = UIStackView()
    
    private let viewModel: ProductDetailViewModel

    // MARK: - Init
    init(product: Product) {
        self.viewModel = ProductDetailViewModel(product: product)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = AppConstants.UI.detailsTitle
        setupUI()
        bindViewModel()
    }
}

// MARK: - Bind ViewModel
extension ProductDetailViewController {
    
    private func bindViewModel() {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.priceText
        ratingLabel.text = viewModel.ratingText
        ratingLabel.textColor = viewModel.ratingColor
        stockLabel.text = viewModel.stockText
        categoryLabel.text = viewModel.category
        brandLabel.text = viewModel.brand
        descriptionLabel.text = viewModel.descriptionText

        specsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.specs.forEach {
            specsStack.addArrangedSubview(makeSpecRow(title: $0.title, value: $0.value))
        }

        productImageView.load(from: viewModel.imageURL)
    }

    private func makeSpecRow(title: String, value: String) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.text = "\(title): \(value)"
        return label
    }
}

// MARK: - Setup UI
private extension ProductDetailViewController {
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        imageContainer.backgroundColor = .secondarySystemBackground
        imageContainer.layer.cornerRadius = 12
        imageContainer.translatesAutoresizingMaskIntoConstraints = false

        productImageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(productImageView)

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 16),
            productImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -16),
            productImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalToConstant: 240)
        ])

        titleLabel.font = .preferredFont(forTextStyle: .headline)

        priceLabel.font = .preferredFont(forTextStyle: .headline)
        
        ratingLabel.font = .preferredFont(forTextStyle: .subheadline)

        stockLabel.font = .preferredFont(forTextStyle: .subheadline)
        stockLabel.textColor = .secondaryLabel
        
        let ratingStockRaw = UIStackView(arrangedSubviews: [ratingLabel, stockLabel])
        ratingStockRaw.axis = .horizontal
        ratingStockRaw.spacing = 12
        ratingStockRaw.alignment = .center
        
        categoryLabel.font = .preferredFont(forTextStyle: .subheadline)
        categoryLabel.textColor = .secondaryLabel
        
        brandLabel.font = .preferredFont(forTextStyle: .subheadline)

        descriptionTitleLabel.text = AppConstants.Messages.descriptionTitle
        descriptionTitleLabel.font = .preferredFont(forTextStyle: .headline)
       
        descriptionLabel.font = .preferredFont(forTextStyle: .callout)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        specsTitleLabel.text = AppConstants.Messages.specsTitle
        specsTitleLabel.font = .preferredFont(forTextStyle: .headline)

        specsStack.axis = .vertical
        specsStack.spacing = 8

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        [
            imageContainer,
            titleLabel,
            priceLabel,
            ratingStockRaw,
            categoryLabel,
            brandLabel,
            UIView.makeDivider(),
            descriptionTitleLabel,
            descriptionLabel,
            UIView.makeDivider(),
            specsTitleLabel,
            specsStack
        ].forEach { contentStack.addArrangedSubview($0) }
        
        contentStack.setCustomSpacing(4, after: descriptionTitleLabel)
        contentStack.setCustomSpacing(4, after: specsTitleLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
}
