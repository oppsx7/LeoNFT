//
//  UserProfileBuilder.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 25/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol UserProfileBuildable {
    func build() -> UIViewController
}

final class UserProfileBuilder: UserProfileBuildable {
    func build() -> UIViewController {
        let viewController = UserProfileViewController()
        let webService = UserProfileWebService()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let interactor = UserProfileInteractor(context: context,
                                               webService: webService)
        let presenter = UserProfilePresenter(view: viewController,
                                             interactor: interactor)

        interactor.output = presenter
        viewController.output = presenter

        return viewController
    }
}
