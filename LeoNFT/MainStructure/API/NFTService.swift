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
                // API returns array with lenght 1
                let response = try JSONDecoder().decode(NFTSingleCollectionResponse.self, from: data!)
                completion(response.collection)
            } catch {
                print(error)
            }
        })
        
        dataTask.resume()
    }
}


// debugwam tuka nqkakwi prostotii
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
