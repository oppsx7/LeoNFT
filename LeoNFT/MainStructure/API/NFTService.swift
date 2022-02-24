//
//  NFTService.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation

let ASSET_LIMIT = 5

struct NFTService {
    
    static func fetchCollections(completion: @escaping([Collection]) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://testnets-api.opensea.io/api/v1/collections?offset=1000&limit=300")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                let collections = try JSONDecoder().decode(NFTCollectionsResponse.self, from: data!)
                completion(collections.collections)
            } catch {
                print(error)
            }
        })

        dataTask.resume()
    }
    
    static func getAssetInfo(_ address: String, _ tokenID: String, completion: @escaping(NFTAssetInfo) -> Void) {

        let request = NSMutableURLRequest(url: NSURL(string: "https://testnets-api.opensea.io/api/v1/asset/\(address)/\(tokenID)/")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let nftAsset = try JSONDecoder().decode(NFTAssetInfo.self, from: data!)
                completion(nftAsset)
            } catch {
                print(error)
            }
        })

        dataTask.resume()
    }
    
    static func getCollectionAssets(_ slug: String, completion: @escaping([NFTAsset]?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://testnets-api.opensea.io/api/v1/assets?order_direction=desc&offset=0&limit=\(ASSET_LIMIT)&collection=\(slug)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let nftAssets = try JSONDecoder().decode(NFTAssetsResponse.self, from: data!)
                completion(nftAssets.assets)
            } catch {
                print(error)
            }

        })
        
        dataTask.resume()
    }
    
    static func getSingleCollection(_ slug: String, completion: @escaping(Collection?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://testnets-api.opensea.io/api/v1/collection/\(slug)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let collection = try JSONDecoder().decode(Collection.self, from: data!)
                completion(collection)
            } catch {
                print(error)
            }
        })
        
        dataTask.resume()
    }
}
