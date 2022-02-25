//
//  FavoritesViewController.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct FavoriteCollectionViewModel {
    let identifier: String
    let title: String
    let image: UIImage
}

protocol FavoritesViewInput: HasLoadingState {
    // Passing business model to the view is not ok but allows for some reusablity in the view class
    func updateView(collections: [Collection])
    func showEmptyState()
}

protocol FavoritesViewOutput {
    func viewIsReady()
}

final class FavoritesViewController: UIViewController {
    private enum Constants {
        static let collectionCellReuseIdentifier = "NFTCollectionTableViewCell"
        static let loadingLabelTag = Int.max - 1
    }
    var output: FavoritesViewOutput?

    private var collectionModels: [Collection] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        UITableView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"

        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NFTCollectionTableViewCell.self,
                           forCellReuseIdentifier: Constants.collectionCellReuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Favorites"

        output?.viewIsReady()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = nil
        collectionModels = []
        if let loadingLabel = view.viewWithTag(Constants.loadingLabelTag) {
            loadingLabel.removeFromSuperview()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.collectionCellReuseIdentifier,
                                                       for: indexPath) as? NFTCollectionTableViewCell,
              indexPath.row < collectionModels.count else {
            return UITableViewCell()
        }
        cell.configure(.init(collection: collectionModels[indexPath.row]))
        cell.selectionStyle = .none
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collectionModels[indexPath.row]
        // would be best if view callsback to presenter with index or some sort of idenifier
        // but i'll have to introduce a router in that case and do more connections
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let collectionViewController = storyboard.instantiateViewController(withIdentifier: "NFTCollectionSingleViewController") as? NFTCollectionSingleViewController else {
            return
        }
        collectionViewController.modalPresentationStyle = .fullScreen
        collectionViewController.collectionVM = NFTCollectionViewModel(collection: collection)
        self.present(collectionViewController, animated: true, completion: nil)
    }
}

extension FavoritesViewController: FavoritesViewInput {
    func updateView(collections: [Collection]) {
        collectionModels = collections
    }

    func showEmptyState() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You have not added any test longer text collections to favorites yet."
        label.tag = Constants.loadingLabelTag
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
