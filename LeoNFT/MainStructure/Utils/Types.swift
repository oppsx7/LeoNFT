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


