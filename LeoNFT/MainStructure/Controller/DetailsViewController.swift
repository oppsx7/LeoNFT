//
//  DetailsViewController.swift
//  LeoNFT
//
//  Created by Petya Krysteva on 24.02.22.
//

import Foundation

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelTxt: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    var details: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //imageView.image = details?.urlToImage
        guard let url = URL(string: (details?.url)!) else{
            print("An error occured with the website")
            return
        }
        spinner.startAnimating()
        webView.load(URLRequest(url: url))
        spinner.stopAnimating()
    }
    

    @IBAction func readMore(_ sender: Any) {
        print("Read more button pressed")
    }
    
}
