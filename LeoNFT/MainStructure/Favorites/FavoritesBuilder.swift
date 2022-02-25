//
//  FavoritesBuilder.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class FavoritesBuilder {
    func build() -> UIViewController {
        let viewController = FavoritesViewController()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let interactor = FavoritesInteractor(context: context)
        let presenter = FavoritesPresenter(view: viewController,
                                           interactor: interactor)

        interactor.output = presenter
        viewController.output = presenter

        return viewController
    }
}
