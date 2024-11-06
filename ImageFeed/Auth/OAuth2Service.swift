import UIKit

// MARK: - OAuth2Service

final class OAuth2Service {
    // MARK: - Properties
    
    static let shared = OAuth2Service()
    private let networkClient = NetworkClient()

    private init() {}

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("LOG: Network Error: invalid url")
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
            assertionFailure("LOG: Network Error: invalid urlComponents")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    // MARK: - Public Methods

    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            assertionFailure("LOG: Network Error: invalid request")
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Выполнение сетевого запроса
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    // Декодирование ответа
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseJSONData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(responseJSONData.accessToken))
                } catch {
                    assertionFailure("LOG: Failed to decode response: \(error.localizedDescription)")
                    handler(.failure(error))
                }
            case .failure(let error):
                assertionFailure("LOG: Network request failed: \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
    }
}
