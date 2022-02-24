//
//  NFTCollectionViewModel.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation
import CoreAudio

struct NFTCollectionViewModel {
    var collection: Collection
    var collectionAssets: [NFTAsset]
    
    init(collection: Collection) {
        self.collection = collection
        self.collectionAssets = []
    }
    
    func isFavorite() -> Bool { collection.favorite }
    
    func collectionName() -> String { collection.name ?? "unknown"}
    
    func collectionSlug() -> String { collection.slug ?? "default"}
    
    func collectionImageURL() -> String { collection.banner_image_url ?? "https://lh3.googleusercontent.com/w6_Or_hlAsAjDOMCWgM51HLcJbA-ulxtSXzcEe6QZIMxx1QUHmCaan6DcvLMyHpQjNLTY0QYwWUNnIczXp1Yj6Ra3lXS0Qb2ZqSOCg=s120" }
    
    func collectionTotalSupply() -> String { getTotalSupplyText() }
    
    func collectionTotalSupplyCount() -> Int { Int(collection.stats?["total_supply"] ?? 0) }
    
    func numberOfOwners() -> Int { Int(collection.stats?["num_owners"] ?? 0)}
    
    func floorPrice() -> Double { collection.stats?["floor_price"] ?? 0.0}
    
    func totalVolumeTraded() -> Double { collection.stats?["total_volume"] ?? 0.0 }
    
    func collectionContractAddress(for index: Int) -> PrimaryAssetContract? { collection.primary_asset_contracts?[index]}
    
    func nftAssetAt(index: Int) -> NFTAsset? {
        guard collectionAssets.count > index else {
            return nil
        }
        return collectionAssets[index]
    }
    
    mutating func setFavoriteProperty(_ isFavorite: Bool) {
        collection.favorite = isFavorite
    }
    
    mutating func setCollectionAssets(_ nftAssets: [NFTAsset]) {
        collectionAssets = nftAssets
    }
    
    private func getTotalSupplyText() -> String {
        let itemString = Int(collection.stats?["total_supply"] ?? 0) == 1 ? " item" : " items"
        return String(Int(collection.stats?["total_supply"] ?? 0)) + itemString
    }
}

struct NFTCollectionsViewModel {
    var collections: [Collection]
    
    var collectionSlugs: [String] = []
    
    init(collections: [Collection]) {
        self.collections = collections
    }
    
    func numberOfCollections() -> Int { collections.count }
    
    func numberOfFavoriteCollections() -> Int { collections.filter({$0.favorite}).count}
    
    func collectionAtIndex(_ index: Int) -> Collection { collections[index] }
    
    func collectionViewModelAtIndex(_ index: Int) -> NFTCollectionViewModel { NFTCollectionViewModel(collection: collections[index]) }
}

class NFTAssetViewModel {
    var nftAsset: NFTAsset
    var assetInfo = NFTAssetInfo()
    
    init(nftAsset: NFTAsset?) {
        self.nftAsset = nftAsset ?? NFTAsset()
    }
    
    func assetName() -> String { nftAsset.name ?? "unknown" }
    
    func assetAddress() -> String { nftAsset.asset_contract.address! }
    
    func assetTokenID() -> String { nftAsset.token_id ?? "1" }
    
    func nftPrice() -> Double { assetInfo.last_sale.payment_token.eth_price ?? 0 }
    
    func isFavorited() -> Bool { nftAsset.favorite }
    
    func setAssetInfo(_ assetInfo: NFTAssetInfo) {
        self.assetInfo = assetInfo
    }
    
}
