//
//  NFTCollectionTableViewCell.swift
//  NFTFetch
//
//  Created by Todor Dimitrov on 22.02.22.
//

import UIKit

class NFTCollectionTableViewCell: UITableViewCell {
    //MARK: - Properties

    var viewModel: NFTCollectionViewModel?


    private let collectionIcon: UIImageView =  {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
    private let collectionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "venom"
        return label
    }()
    
    private let itemNumberText: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Eddie Brock"
        label.textColor = .lightGray
        return label
    }()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(collectionIcon)
        collectionIcon.setDimensions(height: 48, width: 48)
        collectionIcon.layer.cornerRadius = 48 / 2
        collectionIcon.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [collectionTitle, itemNumberText])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: collectionIcon, leftAnchor: collectionIcon.rightAnchor, paddingLeft: 8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers

    func configure(_ viewModel: NFTCollectionViewModel) {
        let url = URL(string: (viewModel.collectionImageURL()))!
        collectionIcon.sd_setImage(with: url)
        collectionTitle.text = viewModel.collectionName()
        itemNumberText.text = viewModel.collectionTotalSupply()
    }

}
