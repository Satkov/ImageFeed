import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTabBarControllers()
    }

    private func setupTabBarControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        // Feed Tab
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let imagesNavController = UINavigationController(rootViewController: imagesListViewController)
        imagesNavController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "feed_button"),
            selectedImage: nil
        )
        imagesNavController.navigationBar.isTranslucent = true
        imagesNavController.navigationBar.backgroundColor = UIColor(named: "YP Black")
        imagesNavController.navigationBar.barTintColor = UIColor(named: "YP Black")

        // Profile Tab
        let profilePageViewController = ProfilePageViewController()
        profilePageViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile_button"),
            selectedImage: nil
        )

        // Add View Controllers to Tab Bar
        viewControllers = [imagesNavController, profilePageViewController]
    }
}
