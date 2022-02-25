//
//  NewsViewCell.swift
//  LeoNFT
//
//  Created by Petya Krysteva on 24.02.22.
//

import Foundation

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var dataTxt: UILabel!
    var url: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dataTxt.numberOfLines = 0
        addShadowAndRoundedCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func askLeoButton(_ sender: Any) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "AskLeo"), object: nil)
    }
    @IBAction func shareNews(_ sender: Any) {
        let text = dataTxt.text
        let image = img.image
        let myWebsite = NSURL(string:url)
        let shareAll = [text! , image! , myWebsite ?? ""] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.view
        
        activityViewController.isModalInPresentation = true
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func addShadowAndRoundedCorners() {
        let radius: CGFloat = 20
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 226.0 / 255.0, green: 232.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0).cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }

}
