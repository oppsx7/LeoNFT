//
//  NewsService.swift
//  LeoNFT
//
//  Created by Petya Krysteva on 24.02.22.
//

import Foundation

import Foundation

struct Parser{
    func fetchNewsData(completionHandler: @escaping ([News]) -> Void) {
        let headers = [
            "x-rapidapi-host": "blockchain-news1.p.rapidapi.com",
            "x-rapidapi-key": "a7b706a20fmshead19c98a69db9cp19957bjsn836574864336"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://blockchain-news1.p.rapidapi.com/news/NDTV")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {return}
            
            do{
                let newsData = try JSONDecoder().decode([News].self, from: data)
                print("Success")
            print(newsData)
                completionHandler(newsData)
            }catch{
                let error = error
                print(error.localizedDescription)
            }

        })
        dataTask.resume()
            
    }

}
