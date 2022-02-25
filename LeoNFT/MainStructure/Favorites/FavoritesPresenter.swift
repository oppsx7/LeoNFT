//
//  FavoritesPresenter.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

final class FavoritesPresenter {
    unowned var view: FavoritesViewInput
    let interactor: FavoritesInteractorInput

    init(view: FavoritesViewInput,
         interactor: FavoritesInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - FavoritesViewOutput

extension FavoritesPresenter: FavoritesViewOutput {
    func viewIsReady() {
        view.startLoadingIndicator()
        interactor.fetchCollections()
    }
}

// MARK: - FavoritesInteractorOutput

extension FavoritesPresenter: FavoritesInteractorOutput {
    func didFetchCollections(collections: [Collection]) {
        view.stopLoadingIndicator()
        // again, we should create a view model and not pass the business model here
        view.updateView(collections: collections)
    }

    func didFetchCollectionsEmpty() {
        view.stopLoadingIndicator()
        view.showEmptyState()
    }
}
