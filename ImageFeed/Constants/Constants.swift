import UIKit

enum Constants {
    static let accessKey: String = "DJG8kbKQOlhnXAnNk_KMXJniTRlDUfEuPgNb8zP21yc"
    static let secretKey: String = "IQ08tN8fsk4FO7YwathZ0qC3vo2UXlSgMjbmh32rjS0"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Invalid URL for defaultBaseURL")
        }
        return url
    }()
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
