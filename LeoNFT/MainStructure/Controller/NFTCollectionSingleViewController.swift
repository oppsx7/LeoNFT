//
//  CollectionSingleViewController.swift
//  NFTFetch
//
//  Created by Todor Dimitrov on 23.02.22.
//

import UIKit

final class NFTCollectionSingleViewController: UIViewController {

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
        Utils.showProgress(forView: self.view)
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
                Utils.hideProgress()
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
        configureFavoriteButton()
    }
    
    @objc func reloadData() {
        self.collectionView.reloadData()
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBAction func didTapFavorite(_ sender: Any) {
        let allCollection = try? context.fetch(NFTCollection.fetchRequest())
        if let currentCollection = allCollection?.first(where: {
            $0.slug == collectionVM.collectionSlug()
        }) {
            // the collection is already liked and need to be removed from the context
            context.delete(currentCollection)
        } else {
            // collection is not present in the context and should be added
            let collenction = NFTCollection(context: context)
            collenction.slug = collectionVM.collectionSlug()
        }
        do {
            try context.save()
        } catch {
            // cant be asked for error handling rn
        }
        configureFavoriteButton()
    }

    private func configureFavoriteButton() {
        let allCollection = try? context.fetch(NFTCollection.fetchRequest())
        let allCollectionSlugs = (allCollection ?? []).map(\.slug)
        let favoriteButtonImageName = allCollectionSlugs.contains(collectionVM.collectionSlug()) ? "like_selected" : "like_unselected"
        favoriteButton.setImage(.init(named: favoriteButtonImageName), for: .normal)
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
