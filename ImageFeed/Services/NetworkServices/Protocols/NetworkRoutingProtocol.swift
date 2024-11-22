import Foundation

protocol NetworkRoutingProtocol {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask
}
