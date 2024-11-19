import UIKit

final class AlertService {

    func showAlert(
        title: String,
        message: String,
        buttonTitle: String,
        on viewController: UIViewController,
        buttonAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }

    func showAlert(
        title: String,
        message: String,
        confirmButtonTitle: String,
        cancelButtonTitle: String,
        on viewController: UIViewController,
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirm = UIAlertAction(title: confirmButtonTitle, style: .default) { _ in
            print("LOG: User confirm logout")
            confirmAction?()
        }
        let cancel = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            print("LOG: User cancel logout")
            cancelAction?()
        }

        alert.addAction(confirm)
        alert.addAction(cancel)

        viewController.present(alert, animated: true)
    }
}
