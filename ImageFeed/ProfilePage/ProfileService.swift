import UIKit

// MARK: - ProfileService

final class ProfileService {
    // MARK: - Properties
    
    static let shared = ProfileService()
    private let networkClient = NetworkClient()
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var profile: ProfilePageModel?

    private init() {}

    // MARK: - Errors

    enum ProfileServiceError: Error {
        case failedToFetchProfileInfo
    }
    
    // MARK: - API URLs

    enum UnsplashProfileURL {
        case me
        case user(username: String)
        
        var urlString: String {
            switch self {
            case .me:
                return "https://api.unsplash.com/me"
            case .user(let username):
                return "https://api.unsplash.com/users/\(username)"
            }
        }
    }

    // MARK: - Request Creation

    private func makeRequestWithUserBearerToken(urlString: String) -> URLRequest? {
        guard let urlComponents = URLComponents(string: urlString) else {
            assertionFailure("LOG: Network Error - Invalid URL")
            return nil
        }

        guard let url = urlComponents.url else {
            assertionFailure("LOG: Network Error - Invalid URL components")
            return nil
        }

        var request = URLRequest(url: url)
        request.addUserBearerToken()
        return request
    }
    
    // MARK: - Fetch Profile
    /// Сначала я сделал так, а в следующем уроке уже дали задачку делать фетч картинок через отдельный сервис
    /// Я понимаю, что это не подходит под тз, но я подумал, что аватарка - такая же часть профиля
    /// как и остальная информация пользователя. Как будто бы не будет ошибкой объединить это все здесь.
    /// Я уже делал подобные функции раньше через диспетч группу и никогда не понимал, насколько это правильно
    /// и можно ли так вообще в реальных проектах, поэтому решил узнать наверняка :)
    func fetchProfile(handler: @escaping (Result<ProfilePageModel, Error>) -> Void) {
        let profileInfoGroup = DispatchGroup()
        let profileImageGroup = DispatchGroup()
        var fetchedProfileInfo: ProfileInfo?
        var fetchedProfileImage: ProfileImage?
        
        profileInfoGroup.enter()
        profileImageGroup.enter()
        
        // Fetch profile info
        fetchProfileInfo() { result in
            defer { profileInfoGroup.leave() }
            switch result {
            case .success(let decodedData):
                fetchedProfileInfo = decodedData
            case .failure(let error):
                handler(.failure(error))
                return
            }
        }
        
        // Fetch profile image
        profileInfoGroup.notify(queue: .main) {
            guard let profileInfo = fetchedProfileInfo else {
                handler(.failure(ProfileServiceError.failedToFetchProfileInfo))
                return
            }
            self.fetchProfileImage(username: profileInfo.username) { result in
                defer { profileImageGroup.leave() }
                switch result {
                case .success(let decodedData):
                    fetchedProfileImage = decodedData
                case .failure(let error):
                    handler(.failure(error))
                    return
                }
            }
        }
        
        // Notify after all tasks are done
        profileImageGroup.notify(queue: .main) {
            if let profileInfo = fetchedProfileInfo, let profileImage = fetchedProfileImage {
                let profilePageModel = self.mergeProfileModels(profileInfo: profileInfo, profileImage: profileImage)
                self.profile = profilePageModel
                handler(.success(profilePageModel))
            } else {
                handler(.failure(ProfileServiceError.failedToFetchProfileInfo))
                return
            }
        }
    }
    
    // MARK: - Merge Profile Models

    private func mergeProfileModels(profileInfo: ProfileInfo, profileImage: ProfileImage) -> ProfilePageModel {
        let fullName = "\(profileInfo.firstName) \(profileInfo.lastName)"
        return ProfilePageModel(
            username: profileInfo.username,
            fullName: fullName,
            bio: profileInfo.bio,
            profileImageURL: profileImage.image.small
        )
    }

    // MARK: - Fetch Profile Info

    private func fetchProfileInfo(handler: @escaping (Result<ProfileInfo, Error>) -> Void) {
        guard let request = makeRequestWithUserBearerToken(urlString: UnsplashProfileURL.me.urlString) else {
            assertionFailure("LOG: Network Error - Invalid request")
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        let task = networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let profileInfo = try decoder.decode(ProfileInfo.self, from: data)
                    handler(.success(profileInfo))
                } catch {
                    assertionFailure("LOG: Decoding error - \(error.localizedDescription)")
                    handler(.failure(error))
                }
            case .failure(let error):
                assertionFailure("LOG: Network request failed - \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Fetch Profile Image

    private func fetchProfileImage(username: String, handler: @escaping (Result<ProfileImage, Error>) -> Void) {
        guard let request = makeRequestWithUserBearerToken(urlString: UnsplashProfileURL.user(username: username).urlString) else {
            assertionFailure("LOG: Network Error - Invalid request")
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        let task = networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let profileImage = try decoder.decode(ProfileImage.self, from: data)
                    handler(.success(profileImage))
                } catch {
                    assertionFailure("LOG: Decoding error - \(error.localizedDescription)")
                    handler(.failure(error))
                }
            case .failure(let error):
                assertionFailure("LOG: Network request failed - \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
        task.resume()
    }
}
