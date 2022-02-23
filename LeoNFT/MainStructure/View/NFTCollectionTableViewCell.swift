//
//  NFTCollectionTableViewCell.swift
//  NFTFetch
//
//  Created by Todor Dimitrov on 22.02.22.
//

import UIKit

class NFTCollectionTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionIcon: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var blockchainSign: UIImageView!
    @IBOutlet weak var itemNumberText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ collectionVM: NFTCollectionViewModel) {
        let url = URL(string: (collectionVM.collectionImageURL()))!
        collectionIcon.sd_setImage(with: url)
        collectionTitle.text = collectionVM.collectionName()
        itemNumberText.text = collectionVM.collectionTotalSupply()
    }

}
