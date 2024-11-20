import Foundation
import SwiftKeychainWrapper
import WebKit

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    static let shared = ProfileLogoutService()

    private let profileService: ProfileServiceProtocol!
    private let profileImageService: ProfileImageServiceProtocol!
    private let imageListService: ImagesListServiceProtocol!

    private init() {
        profileService = ProfileService.shared
        profileImageService = ProfileImageService.shared
        imageListService = ImagesListService.shared

    }

    func logout() {
        cleanCookies()
        removeToken()
    }

    private func cleanCookies() {
        profileService.prepareForLogout()
        profileImageService.prepareForLogout()
        imageListService.prepareForLogout()

        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    private func removeToken() {
        let tokenKey = KeychainWrapper.keychainKeys.userToken
        let isRemoved = KeychainWrapper.standard.removeObject(forKey: tokenKey)

        if isRemoved {
            print("LOG: Token successfully removed.")
        } else {
            print("LOG: Failed to remove token.")
        }
    }
}
