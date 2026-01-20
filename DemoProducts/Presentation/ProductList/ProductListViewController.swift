//
//  ProductListViewController.swift
//  DemoProducts
//
//  Created by IA on 18/01/26.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    // MARK: - UI elements
    private let tableView = UITableView()
    private let loader = UIActivityIndicatorView(style: .large)
    private lazy var footerLoader: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var didRequestNextPage = false
    private let viewModel: ProductListViewModel

    // MARK: - Init
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppConstants.UI.productsTitle
        setupUI()
        bindViewModel()
        Task { await viewModel.loadNextPage() }
    }
}

// MARK: - Bind ViewModel
extension ProductListViewController {
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {

            case .initialLoading:
                loader.startAnimating()
                tableView.tableFooterView = nil

            case .paging:
                loader.stopAnimating()
                tableView.tableFooterView = footerLoader
                footerLoader.startAnimating()

            case .updated:
                didRequestNextPage = false
                loader.stopAnimating()
                footerLoader.stopAnimating()
                tableView.tableFooterView = nil
                tableView.backgroundView = nil

                // Initial load
                if tableView.numberOfRows(inSection: 0) == 0 {
                    tableView.reloadData()
                    return
                }

                // Pagination
                let startIndex = tableView.numberOfRows(inSection: 0)
                let endIndex = startIndex + viewModel.lastFetchedCount

                guard startIndex < endIndex else { return }

                let indexPaths = (startIndex..<endIndex).map {
                    IndexPath(row: $0, section: 0)
                }

                tableView.performBatchUpdates({
                    self.tableView.insertRows(at: indexPaths, with: .none)
                }, completion: nil)

            case .empty:
                loader.stopAnimating()
                footerLoader.stopAnimating()
                tableView.backgroundView = self.makeEmptyView()

            case .error(let message):
                loader.stopAnimating()
                footerLoader.stopAnimating()
                self.showError(message)
            }
        }
    }

    private func showError(_ msg: String) {
        let alert = UIAlertController(title: AppConstants.UI.errorTitle, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.UI.retryTitle, style: .default) { _ in
            Task { await self.viewModel.loadNextPage() }
        })
        present(alert, animated: true)
    }
    
    private func makeEmptyView() -> UIView {
        let label = UILabel()
        label.text = AppConstants.Messages.noData
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }
}

// MARK: - UITableView methods
extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: ProductTableViewCell.reuseId, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let productCellViewModel = ProductCellViewModel(product: viewModel.products[indexPath.row])
        cell.configure(with: productCellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.products.count - 1
        guard indexPath.row == lastIndex else { return }
        guard !didRequestNextPage else { return }
        guard viewModel.products.count > 0 else { return }
        didRequestNextPage = true
        Task { await viewModel.loadNextPage() }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let detailVC = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setup UI
private extension ProductListViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

