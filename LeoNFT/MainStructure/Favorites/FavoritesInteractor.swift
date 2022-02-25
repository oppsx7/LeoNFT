//
//  FavoritesInteractor.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 24/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import CoreData

protocol FavoritesInteractorInput {
    func fetchCollections()
}

protocol FavoritesInteractorOutput: AnyObject {
    func didFetchCollections(collections: [Collection])
    func didFetchCollectionsEmpty()
}

final class FavoritesInteractor {
    weak var output: FavoritesInteractorOutput?

    // Again, we are not adding text but the general good approach would
    // be to make NSManagedObjectContext conform to some protocol and
    // pass that protocol as a type there so we can mock it easly
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        // add some protocol for the context
    }

    private func loadAllCollections(collections: [NFTCollection]) {
        let dispatchGroup = DispatchGroup()
        var fetchedCollections: [Collection] = []
        for collection in collections {
            dispatchGroup.enter()
            NFTService.getSingleCollection(collection.slug ?? "",
                                           completion: { fetchedCollection in
                dispatchGroup.leave()
                if let fetchedCollection = fetchedCollection {
                    fetchedCollections.append(fetchedCollection)
                }
            })
        }
        dispatchGroup.notify(queue: .main,
                             execute: { [weak output] in
                                 let filteredCollections = fetchedCollections.filter {
                                     $0.banner_image_url != nil
                                 }
                                 output?.didFetchCollections(collections: filteredCollections)
        })
    }
}

// MARK: - FavoritesInteractorInput

extension FavoritesInteractor: FavoritesInteractorInput {
    func fetchCollections() {
        do {
            let collections = try context.fetch(NFTCollection.fetchRequest())
            if collections.count > 0 {
                loadAllCollections(collections: collections)
            } else {
                output?.didFetchCollectionsEmpty()
            }
        } catch {
            fatalError("Error handling would be better, but oh well ...")
        }
    }
}
