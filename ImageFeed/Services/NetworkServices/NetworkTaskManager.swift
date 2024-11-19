import UIKit

// MARK: - NetworkTaskManager

final class NetworkTaskManager: NetworkTaskManagerProtocol {

    private let networkClient: NetworkRoutingProtocol
    private let requestCacheManager: RequestCacheManagerProtocol!

    init() {
        requestCacheManager = RequestCacheManager.shared
        networkClient = NetworkClient()
    }
    // MARK: - Task Creation

    func performRequest(
        request: URLRequest,
        updateState: (() -> Void)? = nil,
        handler: @escaping (Result<Void, Error>) -> Void
    ) -> URLSessionTask {

        return networkClient.fetch(request: request) { result in
            switch result {
            case .success:
                updateState?()
                handler(.success(()))
            case .failure(let error):
                self.logAndHandleError(error, handler: handler)
            }
        }
    }

    func performDecodedRequest<T: Decodable>(
        request: URLRequest,
        updateState: ((T) -> Void)? = nil,
        cacheKey: String? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        cacheIdentifier: String? = nil,
        handler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {

        return networkClient.fetch(request: request) { result in
            self.handleFetchResult(result, updateState: updateState, decoder: decoder, handler: handler)

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
        decoder: JSONDecoder,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        switch result {
        case .success(let data):
            decodeData(data, updateState: updateState, decoder: decoder, handler: handler)
        case .failure(let error):
            logAndHandleError(error, handler: handler)
        }
    }

    private func decodeData<T: Decodable>(
        _ data: Data,
        updateState: ((T) -> Void)?,
        decoder: JSONDecoder,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            updateState?(decodedData)
            handler(.success(decodedData))
        } catch {
            logAndHandleError(error, handler: handler)
        }
    }

    private func logAndHandleError<T>(
        _ error: Error,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        logError(message: "Network request failed ", error: error)
        handler(.failure(error))
    }
}
