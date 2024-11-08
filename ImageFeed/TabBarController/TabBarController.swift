import UIKit

class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )

        let imagesNavController = UINavigationController(rootViewController: imagesListViewController)
        imagesNavController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "feed_button"),
            selectedImage: nil)

        let ProfilePageViewController = ProfilePageViewController()
        ProfilePageViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "profile_button"),
            selectedImage: nil)

        self.viewControllers = [imagesNavController, ProfilePageViewController]
    }
}
