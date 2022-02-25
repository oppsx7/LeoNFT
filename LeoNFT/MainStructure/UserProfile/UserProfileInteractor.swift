//
//  UserProfileInteractor.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 25/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import CoreData

protocol UserProfileInteractorInput {
    func loadUserInfo()
    func updateUsername(newUsername: String)
}

protocol UserProfileInteractorOutput: AnyObject {
    func didLoadUserInfo(user: User, favoritedCollections: Int)
    func didUpdateUsername()
    func didFailUpdatingUsername()
}

final class UserProfileInteractor {
    weak var output: UserProfileInteractorOutput?

    private let context: NSManagedObjectContext
    private let webService: UserProfileWebServiceProtocol

    init(context: NSManagedObjectContext,
         webService: UserProfileWebServiceProtocol) {
        self.context = context
        self.webService = webService
    }
}

// MARK: - UserProfileInteractorInput

extension UserProfileInteractor: UserProfileInteractorInput {
    func loadUserInfo() {
        webService.getCurrentUserStats(completion: { [weak self] user in
            do {
                let collections = try self?.context.fetch(NFTCollection.fetchRequest())
                self?.output?.didLoadUserInfo(user: user,
                                              favoritedCollections: collections?.count ?? 0)
            } catch {
                fatalError("Error handling would be better, but oh well ...")
            }
        })
    }

    func updateUsername(newUsername: String) {
        webService.updateUsername(newUsername: newUsername,
                                  completion: { [weak output] result in
            switch result {
            case .success:
                output?.didUpdateUsername()
            case .failure(let error):
                // errorhandling, but no
                output?.didFailUpdatingUsername()
            }
        })
    }
}

// Move to new file
protocol UserProfileWebServiceProtocol {
    func getCurrentUserStats(completion: @escaping ((User) -> Void))
    func updateUsername(newUsername: String,
                        completion: @escaping ((Result<Void, Error>) -> Void))
}

final class UserProfileWebService: UserProfileWebServiceProtocol {
    func getCurrentUserStats(completion: @escaping (User) -> Void) {
        UserService.fetchUser(completion: completion)
    }

    func updateUsername(newUsername: String,
                        completion: @escaping ((Result<Void, Error>) -> Void)) {
        UserService.updateCurrentUserUsername(newUsername: newUsername,
                                              completion: completion)
    }
}
