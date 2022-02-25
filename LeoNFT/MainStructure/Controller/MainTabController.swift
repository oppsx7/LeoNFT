import Foundation
import UIKit
import Firebase

final class MainTabController: UITabBarController {
    private let favoritesBuilder = FavoritesBuilder()
    private let userProfileBuilder = UserProfileBuilder()
    //MARK: - Lifecycle
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(with: user)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
//        logout()
    }

    //MARK: - API

    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }

        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }

    //MARK: - Helpers

    func configureViewControllers(with user: User) {
        self.tabBar.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        let sb = UIStoryboard(name: "NewsStoryBoard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewsViewController")
        let feed = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: vc)
        let search = templateNavigationController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchController())
        let favoritesViewController = favoritesBuilder.build()
        let favoritesNavigationController = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!,
                                                                         selectedImage: UIImage(named: "like_selected")!,
                                                                         rootViewController: favoritesViewController)

        let profileController = userProfileBuilder.build()
        let profile = templateNavigationController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: profileController)
        
        viewControllers = [feed, search, favoritesNavigationController, profile]
        
        tabBar.tintColor = .black
    }

    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = .white
        view.backgroundColor = .white

        return nav
    }
}
//MARK: - AuthenticationDelegate
extension MainTabController: AuthenticationDelegate {
    func authenticationComplete() {
        print("DEBUG: Auth did complete. Fetch user and update here..")
        fetchUser()
        self.dismiss(animated: true)
    }
}
