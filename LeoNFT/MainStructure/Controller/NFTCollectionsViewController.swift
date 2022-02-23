//
//  NFTCollectionsViewController.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation
import UIKit

class NFTCollectionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var collectionsVM: NFTCollectionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCollections()
    }
    
    
    func fetchCollections() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://testnets-api.opensea.io/api/v1/collections?offset=200&limit=300")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            do {
                let collections = try JSONDecoder().decode(NFTCollectionsResponse.self, from: data!)
                self.collectionsVM = NFTCollectionsViewModel(collections: collections.collections.filter({$0.banner_image_url != nil}))
                print("Collections count: \(self.collectionsVM.numberOfCollections())")
            } catch {
                print(error)
            }
        })

        dataTask.resume()
    }
}

//MARK: UITableView
extension NFTCollectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionsVM.numberOfCollections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NFTCollectionTableViewCell", for: indexPath) as? NFTCollectionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(collectionsVM.collectionViewModelAtIndex(indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
