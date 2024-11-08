import UIKit

// MARK: - NetworkTaskManager

final class NetworkTaskManager {

    private let networkClient = NetworkClient()
    private let requestCacheManager = RequestCacheManager.shared

    // MARK: - Task Creation

    func performDecodedRequest<T: Decodable>(
        request: URLRequest,
        updateState: ((T) -> Void)? = nil,
        cacheKey: String? = nil,
        cacheIdentifier: String? = nil,
        handler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {

        return networkClient.fetch(request: request) { result in
            self.handleFetchResult(result, updateState: updateState, handler: handler)

            // Обновление кэша после завершения задачи
            if let key = cacheKey, let identifier = cacheIdentifier {
                self.requestCacheManager.setActiveTask(nil, for: key, with: identifier)
            }
        }
    }

    // MARK: - Helper Methods

    private func handleFetchResult<T: Decodable>(
        _ result: Result<Data, Error>,
        updateState: ((T) -> Void)?,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        switch result {
        case .success(let data):
            decodeData(data, updateState: updateState, handler: handler)
        case .failure(let error):
            logAndHandleError(error, handler: handler)
        }
    }

    private func decodeData<T: Decodable>(
        _ data: Data,
        updateState: ((T) -> Void)?,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self, from: data)
            updateState?(decodedData)
            handler(.success(decodedData))
        } catch {
            assertionFailure("LOG: Decoding error - \(error.localizedDescription)")
            handler(.failure(error))
        }
    }

    private func logAndHandleError<T>(
        _ error: Error,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        assertionFailure("LOG: Network request failed - \(error.localizedDescription)")
        handler(.failure(error))
    }
}
