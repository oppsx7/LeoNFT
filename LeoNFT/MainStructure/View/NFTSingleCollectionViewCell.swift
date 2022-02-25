//
//  NFTSingleCollectionViewCell.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 24.02.22.
//

import Foundation
import UIKit


class NFTSingleCollectionViewCell: UICollectionViewCell {
    
    var assetVM: NFTAssetViewModel!
    
    @IBOutlet weak var assetIV: UIImageView!
    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var assetPrice: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    func setup(assetVM: NFTAssetViewModel, floorPrice: Double) {
        if floorPrice != 0 {
            NFTService.getAssetInfo(assetVM.assetAddress(), assetVM.assetTokenID()) { assetInfo in
                assetVM.setAssetInfo(assetInfo)
                let url = URL(string: assetVM.nftAsset.image_url!)!
                DispatchQueue.main.async {
                    self.assetIV.sd_setImage(with: url)
                    self.assetName.text = assetVM.assetName()
                    self.assetPrice.text = String(assetVM.nftPrice())
                }
                
            }
        } else {
            let url = URL(string: assetVM.getImageURL())
            self.assetIV.sd_setImage(with: url)
            self.assetName.text = assetVM.assetName()
            self.assetPrice.text = "Price: \(assetVM.nftPrice()) ETH"
            self.assetPrice.sizeToFit()
        }
        
    }
}
