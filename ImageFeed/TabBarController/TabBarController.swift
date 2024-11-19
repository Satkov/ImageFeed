import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTabBarControllers()
    }

    private func setupTabBarControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        // Feed Tab
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        guard let imagesListVC = imagesListViewController as? ImagesListViewController else {
            fatalError("Could not cast to ImagesListViewController")
        }
        let imagesNavController = UINavigationController(rootViewController: imagesListViewController)
        let imageListPresenter = ImageListPresenter()
        imagesListVC.configure(imageListPresenter)
        
        imagesNavController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "feed_button"),
            selectedImage: nil
        )
        
        // Profile Tab
        let profilePageViewController = ProfilePageViewController()
        let profilePagePresenter = ProfilePagePresenter()
        profilePageViewController.configure(profilePagePresenter)
        profilePageViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile_button"),
            selectedImage: nil
        )

        // Add View Controllers to Tab Bar
        viewControllers = [imagesNavController, profilePageViewController]
    }
}
