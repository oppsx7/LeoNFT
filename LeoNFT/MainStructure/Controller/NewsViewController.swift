//
//  NewsViewController.swift
//  LeoNFT
//
//  Created by Petya Krysteva on 24.02.22.
//

import Foundation
import UIKit
import Firebase


class NewsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var parser = Parser()
    var listOfArticles = [News]()
    var filteredNews = [News]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leoVE: UIVisualEffectView!
    @IBOutlet weak var leoVSImage: UIImageView!
    @IBOutlet weak var buttonDone: UIButton!
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Search"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parser.fetchNewsData { (data) in
            self.listOfArticles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        filteredNews = listOfArticles
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(showLeo), name: NSNotification.Name(rawValue: "AskLeo"), object: nil)
    
    
    }
    
    @objc func showLeo(){
        let  randumN = Int.random(in: 1..<6)
        
        switch randumN {
        case 1: leoVSImage.image = UIImage(named: "lеo1")
        case 2: leoVSImage.image = UIImage(named: "lеo2")
        case 3: leoVSImage.image = UIImage(named: "lеo3")
        case 4: leoVSImage.image = UIImage(named: "lеo4")
        case 5: leoVSImage.image = UIImage(named: "lеo5")
        default:
            leoVSImage.image = UIImage(named: "leo1")
        }
       
        leoVE.isHidden = false
        leoVSImage.isHidden = false
        
    }
    
    func filterContentForSearchText(searchText:String) {
        filteredNews = listOfArticles.filter({$0.title?.contains(searchText) ?? false})
    
    }
    
    @objc private func didPullToRefresh(){
        
        parser.fetchNewsData { (data) in
            self.listOfArticles = data
            DispatchQueue.main.async {
                //self.listOfArticles.removeAll()
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        leoVE.isHidden = true
    }
    
    
    //MARK: - Actions
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBar.backgroundColor = .white
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    //MARK: - Helpers
    
    func isFiltering()->Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    func configureUI() {
        tableView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "News"
        navigationItem.searchController = searchController
        
    }
    
    
    
    //MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredNews.count : listOfArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        let news = isFiltering() ? filteredNews[indexPath.row]  : listOfArticles[indexPath.row]

        cell.dataTxt.text = news.title
        cell.url = news.url ?? ""
        let url:NSURL = NSURL(string: news.img!)!
        do {
            let data:NSData = try NSData(contentsOf: url as URL, options: .mappedIfSafe)

            cell.img.image = UIImage(data: data as Data)// Error here
            

        } catch {}
         
        return cell
    }
    
    //Move the next detailed view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "next", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "next"{
            let vc = segue.destination as! DetailViewController
            vc.details = listOfArticles[(tableView.indexPathForSelectedRow?.row)!]
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
}

extension NewsViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text ?? "")
        self.tableView.reloadData()
    }
}

extension NewsViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText:searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }}


