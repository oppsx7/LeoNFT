//
//  CollectionSingleViewController.swift
//  NFTFetch
//
//  Created by Todor Dimitrov on 23.02.22.
//

import UIKit

class NFTCollectionSingleViewController: UIViewController {

    @IBOutlet weak var collectionBannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //items count
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    
    //owners count
    @IBOutlet weak var ownersCountLabel: UILabel!
    @IBOutlet weak var ownersLabel: UILabel!
    
    //floor price
    @IBOutlet weak var floorPriceCountLabel: UILabel!
    @IBOutlet weak var floorPriceLabel: UILabel!
    
    //volume traded
    @IBOutlet weak var volumeTradedCountLabel: UILabel!
    @IBOutlet weak var volumeTradedLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
