import Foundation
import UIKit
import JGProgressHUD

private let reuseIdentifier = "NFTCollectionTableViewCell"

class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var collectionsVM: NFTCollectionsViewModel!
    private var filteredCollections = [Collection]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        Utils.showProgress(forView: (navigationController?.view)!)
        Utils.showProgress()
        configureTableView()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCollections()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(NFTCollectionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
        
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    //MARK: - API
    func fetchCollections() {
        NFTService.fetchCollections { collections in
            
            self.collectionsVM = NFTCollectionsViewModel(collections: collections.filter({$0.banner_image_url != nil}))
            collections.forEach({ collection in
                self.collectionsVM.collectionSlugs.append(collection.slug ?? "")
            })
            DispatchQueue.main.async {
                Utils.hideProgress()
                self.tableView.reloadData()
                
            }
            print("Collections count: \(self.collectionsVM.numberOfCollections())")
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard collectionsVM != nil else { return 0 }
        return inSearchMode ? filteredCollections.count : collectionsVM.numberOfCollections()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NFTCollectionTableViewCell
        let collection = inSearchMode ? filteredCollections[indexPath.row] : collectionsVM.collectionAtIndex(indexPath.row)
        cell.configure(NFTCollectionViewModel(collection: collection))
        return cell
    }
}

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = inSearchMode ? filteredCollections[indexPath.row] : collectionsVM.collectionAtIndex(indexPath.row)
        //MARK: TODO
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NFTCollectionSingleViewController") as! NFTCollectionSingleViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        vc.collectionVM = NFTCollectionViewModel(collection: collection)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        //MARK: TODO
        
        if collectionsVM.collections.filter({ ($0.name?.lowercased().contains(searchText.lowercased()))!}).count != 0 {            filteredCollections = collectionsVM.collections.filter({ ($0.name?.lowercased().contains(searchText.lowercased()))!})
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionsVM.collectionSlugs.forEach { slug in
                    if slug.lowercased().contains(searchText.lowercased()) {
                        NFTService.getSingleCollection(slug) { collection in
                            if let collection = collection {
                                self.filteredCollections.removeAll()
                                self.filteredCollections.append(collection)
                            }
                            
                        }
                    }
                }
                
            }
            
        }
         
        print("DEBUG: Filtered collections \(filteredCollections)")
        self.tableView.reloadData()
    }
}
