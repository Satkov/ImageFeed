import UIKit

// MARK: - ProfileService

final class ProfileService {

    // MARK: - Properties

    static let shared = ProfileService()
    private let networkTaskManager = NetworkTaskManager()
    private let requestCacheManager = RequestCacheManager.shared
    private(set) var profile: ProfileInfo?

    private init() {}

    // MARK: - API URLs

    private enum UnsplashProfileURL {
        static let me = "https://api.unsplash.com/me"
    }

    // MARK: - Request Creation

    private func makeAuthenticatedRequest(for urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            logError(message: "Network Error - Invalid URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.addUserBearerToken()
        return request
    }

    // MARK: - Fetch Profile

    func fetchProfile(handler: @escaping (Result<ProfileInfo, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.fetchProfile(handler: handler)
                return
            }
        }

        // Проверка на дубликат запроса
        let cacheKey = "ProfileService"
        if requestCacheManager.isDuplicateRequest(for: cacheKey, identifier: "") {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Отменяем предыдущий запрос, если он активен
        requestCacheManager.cancelTask(for: cacheKey)

        guard let request = makeAuthenticatedRequest(for: UnsplashProfileURL.me) else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Обновление состояния профиля после успешного запроса
        let updateState: (ProfileInfo) -> Void = { [weak self] profile in
            self?.profile = profile
        }

        // Выполнение сетевого запроса
        let task = networkTaskManager.performDecodedRequest(
            request: request,
            updateState: updateState,
            cacheKey: cacheKey,
            cacheIdentifier: "",
            handler: handler
        )

        requestCacheManager.setActiveTask(task, for: cacheKey, with: "")
        task.resume()
    }
}
