import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service() 
    private let networkClient = NetworkClient()
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
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
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            assertionFailure("LOG: Network Error: invalid request")
            handler(.failure(NetworkError.invalidRequest))
            return
        }
        
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let accessToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(accessToken))
                } catch {
                    assertionFailure("LOG: Failed to decode response: \(error)")
                    handler(.failure(error))
                }
            case .failure(let error):
                assertionFailure("LOG: Network request failed: \(error)")
                handler(.failure(error))
            }
        }
    }
}


