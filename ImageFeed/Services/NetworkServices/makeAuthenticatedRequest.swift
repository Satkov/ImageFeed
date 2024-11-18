import Foundation

func makeAuthenticatedRequest(for urlString: String, urlQueryItems: [URLQueryItem]? = nil) -> URLRequest? {
    guard var urlComponents = URLComponents(string: urlString) else {
        logError(message: "Network Error - Invalid URL")
        return nil
    }

    // Добавляем queryItems к urlComponents
    if let urlQueryItems = urlQueryItems {
        urlComponents.queryItems = urlQueryItems
    }

    guard let finalURL = urlComponents.url else {
        logError(message: "Network Error - Invalid URLComponents")
        return nil
    }

    var request = URLRequest(url: finalURL)
    request.addUserBearerToken()
    return request
}
