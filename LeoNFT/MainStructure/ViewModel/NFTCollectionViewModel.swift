//
//  NFTCollectionViewModel.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation

struct NFTCollectionViewModel {
    var collection: Collection
    
    func isFavorite() -> Bool { collection.favorite }
    
    func collectionName() -> String { collection.name ?? "unknown"}
    
    func collectionImageURL() -> String { collection.banner_image_url ?? "" }
    
    func collectionTotalSupply() -> String { String(collection.stats?["total_supply"] ?? 0) + " items" }
    
    mutating func setFavoriteProperty(_ isFavorite: Bool) {
        collection.favorite = isFavorite
    }
}

struct NFTCollectionsViewModel {
    var collections: [Collection]
    
    func numberOfCollections() -> Int { collections.count }
    
    func numberOfFavoriteCollections() -> Int { collections.filter({$0.favorite}).count}
    
    func collectionAtIndex(_ index: Int) -> Collection { collections[index] }
    
    func collectionViewModelAtIndex(_ index: Int) -> NFTCollectionViewModel { NFTCollectionViewModel(collection: collections[index]) }
}
