import UIKit

// MARK: - ProfileImageService

final class ProfileImageService {

    // MARK: - Properties

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let profileService = ProfileService.shared
    private let networkTaskManager = NetworkTaskManager()
    private let requestCacheManager = RequestCacheManager.shared
    private(set) var profileImageURL: ProfileImageURL?

    private init() {}

    // MARK: - API URLs

    private enum UnsplashProfileURL {
        static func user(username: String) -> String {
            return "https://api.unsplash.com/users/\(username)"
        }
    }

    // MARK: - Fetch Profile Image

    func fetchProfileImage(handler: @escaping (Result<ProfileImageURL, Error>) -> Void) {

        guard let username = profileService.profile?.username else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        fetchProfileImageURL(username: username, handler: handler)
    }

    private func fetchProfileImageURL(username: String, handler: @escaping (Result<ProfileImageURL, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.fetchProfileImageURL(username: username, handler: handler)
                return
            }
        }

        let cacheKey = "ProfileImageService"

        // Проверка на дубликат запроса
        if requestCacheManager.isDuplicateRequest(for: cacheKey, identifier: username) {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Отменяем предыдущий запрос для этого ключа
        requestCacheManager.cancelTask(for: cacheKey)

        // Создаем request
        guard let request = makeAuthenticatedRequest(for: UnsplashProfileURL.user(username: username)) else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        // Обновление состояния профиля после успешного запроса
        let updateState: (ProfileImageURL) -> Void = { [weak self] decodedData in
            self?.profileImageURL = decodedData
            NotificationCenter.default
                .post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": decodedData.image.small])
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Выполнение сетевого запроса
        let task = networkTaskManager.performDecodedRequest(
            request: request,
            updateState: updateState,
            cacheKey: cacheKey,
            decoder: decoder,
            cacheIdentifier: username,
            handler: handler
        )

        requestCacheManager.setActiveTask(task, for: cacheKey, with: username)
        task.resume()
    }
    
    func prepareForLogout() {
        profileImageURL = nil
    }
}
