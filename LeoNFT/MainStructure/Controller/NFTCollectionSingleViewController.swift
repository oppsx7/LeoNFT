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
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var collectionVM: NFTCollectionViewModel!
    
    let reuseIdentifier = "NFTSingleCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("ReloadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NFTService.getCollectionAssets(collectionVM.collectionSlug()) { assets in
            self.collectionVM.setCollectionAssets(assets ?? [])
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setup() {
        let url = URL(string: (collectionVM.collectionImageURL()))!
        collectionBannerImageView.sd_setImage(with: url)
        titleLabel.text = collectionVM.collectionName()
        itemsCountLabel.text = String(collectionVM.collectionTotalSupplyCount())
        ownersCountLabel.text = String(collectionVM.numberOfOwners())
        floorPriceCountLabel.text = String(collectionVM.floorPrice())
        volumeTradedCountLabel.text = String(collectionVM.totalVolumeTraded())
    }
    
    @objc func reloadData() {
        self.collectionView.reloadData()
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {

    }
}


extension NFTCollectionSingleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionVM.collectionTotalSupplyCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NFTSingleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(assetVM: NFTAssetViewModel(nftAsset: collectionVM.nftAssetAt(index: indexPath.row)), floorPrice: collectionVM.floorPrice())
        
        return cell
    }
    
    
}
