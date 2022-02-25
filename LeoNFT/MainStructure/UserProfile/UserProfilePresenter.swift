//
//  UserProfilePresenter.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 25/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

final class UserProfilePresenter {
    unowned var view: UserProfileViewInput
    let interactor: UserProfileInteractorInput

    init(view: UserProfileViewInput,
         interactor: UserProfileInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
}

// MARK: - UserProfileViewOutput

extension UserProfilePresenter: UserProfileViewOutput {
    func viewIsReady() {
        view.startLoadingIndicator()
        interactor.loadUserInfo()
    }

    func didTapEditProfile() {
        // should take params for possible options to edit profile
        view.showEditProfileModal()
    }

    func didSelectEditUsername() {
        view.showTextInput()
    }

    func didSelectChangeProfilePickture() {
        // no implementation
    }

    func didEnterNewUsername(newUsername: String) {
        view.stopLoadingIndicator()
        interactor.updateUsername(newUsername: newUsername)
    }
}

// MARK: - UserProfileInteractorOutput

extension UserProfilePresenter: UserProfileInteractorOutput {
    func didLoadUserInfo(user: User, favoritedCollections: Int) {
        view.stopLoadingIndicator()
        // again business model -> view model
        let collectionString = favoritedCollections == 1 ? "1 favorited collection" : "\(favoritedCollections) favorited collections"
        view.updateView(user: user,
                        favoritedCollectionString: collectionString)
    }

    func didUpdateUsername() {
        interactor.loadUserInfo() // making sure that everying is fresh
    }

    func didFailUpdatingUsername() {
        view.stopLoadingIndicator()
        // appropriate handling
    }
}
