import UIKit

// MARK: - ProfileService

final class ProfileService: ProfileServiceProtocol {

    // MARK: - Properties

    static let shared = ProfileService()

    private let networkTaskManager: NetworkTaskManagerProtocol
    private let requestCacheManager: RequestCacheManagerProtocol
    private(set) var profile: ProfileInfo?

    private init() {
        networkTaskManager = NetworkTaskManager()
        requestCacheManager = RequestCacheManager.shared
    }

    // MARK: - API URLs

    private enum UnsplashProfileURL {
        static let me = "https://api.unsplash.com/me"
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
            logError(message: "Duplicated request in fetchProfile")
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

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Выполнение сетевого запроса
        let task = networkTaskManager.performDecodedRequest(
            request: request,
            updateState: updateState,
            cacheKey: cacheKey,
            decoder: decoder,
            cacheIdentifier: "",
            handler: handler
        )

        requestCacheManager.setActiveTask(task, for: cacheKey, with: "")
        task.resume()
    }

    func prepareForLogout() {
        profile = nil
    }
}
