//
//  Types.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation
// MARK: - NFTCollectionsResponse
struct NFTCollectionsResponse: Codable {
    let collections: [Collection]
}

// MARK: - Collection
struct Collection: Codable {
    //this is a computed property in order to be automatically excluded from CodingKeys
    var favorite: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    let primary_asset_contracts: [PrimaryAssetContract]?
    let traits: Traits?
    let stats: [String: Double]?
    let banner_image_url, chat_url: String?
    let created_date: String?
    let default_to_fiat: Bool?
    let description: String?
    let dev_buyer_fee_basis_points, dev_seller_fee_basis_points: String?
    let discord_url: String?
    let display_data: DisplayData?
    let external_url: String?
    let featured: Bool?
    let featured_image_url: String?
    let hidden: Bool?
    let safelist_request_status: String?
    let image_url: String?
    let is_subject_to_whitelist: Bool?
    let large_image_url, medium_username: String?
    let name: String?
    let only_proxied_transfers: Bool?
    let opensea_buyer_fee_basis_points, opensea_seller_fee_basis_points: String?
    let payout_address: String?
    let require_email: Bool?
    let short_description: String?
    let slug: String?
    let telegram_url, twitter_username, instagram_username, wiki_url: String?
}

// MARK: - DisplayData
struct DisplayData: Codable {
    let card_display_style: String
}

// MARK: - PrimaryAssetContract
struct PrimaryAssetContract: Codable {
    let address, asset_contract_type, created_date, name: String?
    let nft_version: String?
    let opensea_version: String?
    let owner: Int?
    let schema_name, symbol, total_supply: String?
    let description, external_link, image_url: String?
    let default_to_fiat: Bool?
    let dev_buyer_fee_basis_points, dev_seller_fee_basis_points: Double?
    let only_proxied_transfers: Bool?
    let opensea_buyer_fee_basis_points, opensea_seller_fee_basis_points, buyer_fee_basis_points, seller_fee_basis_points: Double?
    let payout_address: String?
}

// MARK: - Traits
struct Traits: Codable {
}

struct NFTAssetsResponse: Codable {
    var next: String?
    var previous: String?
    var assets: [NFTAsset]?
}

class NFTAsset: Codable {
    var favorite: Bool {
        get {
            return false
        }
        
        set {
            
        }
    }
    var id: Int? = 0
    var background_color: String? = ""
    var image_url: String? = DEFAULT_URL
    var image_preview_url: String? = DEFAULT_URL
    var image_thumbnail_url: String? = DEFAULT_URL
    var image_original_url: String? = DEFAULT_URL
    var name: String? = ""
    var description: String? = ""
    var external_link: String? = ""
    var asset_contract: AssetContract = AssetContract()
    var permalink: String = ""
//    var owner: Creator
//    var creator: Creator
//    var last_sale: LastSale = LastSale()
    var highest_buyer_commitment: String? = ""
    var token_id: String? = ""
}

class NFTAssetInfo: Codable {
    var last_sale: LastSale = LastSale()
    var id: Int? = 0
    var background_color: String? = ""
    var image_url: String? = DEFAULT_URL
    var image_preview_url: String? = DEFAULT_URL
    var image_thumbnail_url: String? = DEFAULT_URL
    var image_original_url: String? = DEFAULT_URL
    var name: String? = ""
    var description: String? = ""
    var external_link: String? = ""
    var permalink: String = ""
//    var owner: Creator
//    var creator: Creator
//    var last_sale: LastSale = LastSale()
    var highest_buyer_commitment: String? = ""
    var token_id: String? = ""
}

// MARK: - AssetContract
struct AssetContract: Codable {
    var address: String? = ""
    var name: String? = ""
    var owner: Int? = 0
    var symbol: String? = ""
    var description: String? = ""
    var image_url: String? = ""
    var payout_address: String? = ""
}

//
//// MARK: - PaymentTokenElement
//struct PaymentTokenElement: Codable {
//    let id: Int
//    let symbol: String?
//    let address: String
//    let image_url: String
//    let name: String?
//    let decimals: Int
//    let ethPrice: Int?
//    let usdPrice: Double?
//}

//// MARK: - Creator
//struct Creator: Codable {
//    let profile_img_url: String
//    let address, config: String
//}


// MARK: - LastSale
struct LastSale: Codable {
    var asset: Asset = Asset()
    var asset_bundle: String? = ""
    var event_type: String? = ""
    var event_timestamp: String? = ""
    var auction_type: String? = ""
    var total_price: String? = ""
    var payment_token: LastSalePaymentToken = LastSalePaymentToken()
//    var transaction: Transaction
    var createdDate: String? = ""
    var quantity: String? = ""
}

// MARK: - Asset
struct Asset: Codable {
    var decimals: Int? = 0
    var token_id: String? = ""
}

// MARK: - LastSalePaymentToken
struct LastSalePaymentToken: Codable {
    var id: Int? = 0
    var symbol: String? = ""
    var address: String? = ""
    var image_url: String? = ""
    var name: String? = ""
    var decimals: Int? = 0
    var eth_price: Double? = 0
    var usd_price: Double? = 0
}

//// MARK: - Transaction
//struct Transaction: Codable {
//    let block_hash, block_number: String
//    let from_account: Creator
//    let id: Int
//    let timestamp: String
//    let to_account: Creator
//    let transaction_hash, transaction_index: String
//}
//
//// MARK: - TopOwnership
//struct TopOwnership: Codable {
//    let owner: Creator
//    let quantity: String
//}

// MARK: - Trait
struct Trait: Codable {
    let trait_type, value: String
    let trait_count: Int
}


