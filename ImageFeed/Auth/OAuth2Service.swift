import UIKit

// MARK: - OAuth2Service

final class OAuth2Service {

    // MARK: - Properties

    static let shared = OAuth2Service()
    private let networkTaskManager = NetworkTaskManager()
    private let requestCacheManager = RequestCacheManager.shared
    private let cacheKey = "OAuth2Service"

    private init() {}

    // MARK: - Request Creation

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            logError(message: "Network Error: Invalid URL")
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        guard let url = urlComponents.url else {
            logError(message: "Network Error: Invalid URL components")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }

    // MARK: - Public Methods

    func fetchOAuthToken(code: String, handler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.fetchOAuthToken(code: code, handler: handler)
                return
            }
        }

        // Проверка на дубликат запроса
        if requestCacheManager.isDuplicateRequest(for: cacheKey, identifier: code) {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Отменяем предыдущий запрос с этим кодом
        requestCacheManager.cancelTask(for: cacheKey)

        guard let request = makeOAuthTokenRequest(code: code) else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Выполнение сетевого запроса
        let task = networkTaskManager.performDecodedRequest(
            request: request,
            cacheKey: cacheKey,
            decoder: decoder,
            cacheIdentifier: code,
            handler: handler
        )

        // Сохраняем активную задачу
        requestCacheManager.setActiveTask(task, for: cacheKey, with: code)
        task.resume()
    }
}
