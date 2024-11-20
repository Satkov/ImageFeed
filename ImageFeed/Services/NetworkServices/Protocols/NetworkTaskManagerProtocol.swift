import UIKit

protocol NetworkTaskManagerProtocol: AnyObject {
    func performRequest(
        request: URLRequest,
        updateState: (() -> Void)?,
        handler: @escaping (Result<Void, Error>) -> Void
    ) -> URLSessionTask

    func performDecodedRequest<T: Decodable>(
        request: URLRequest,
        updateState: ((T) -> Void)?,
        cacheKey: String?,
        decoder: JSONDecoder,
        cacheIdentifier: String?,
        handler: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask
}
