import Foundation

struct NetworkClient: NetworkRoutingProtocol {

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let fulfillHandlerOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                logError(message: "Network error occurred", error: error)
                fulfillHandlerOnTheMainThread(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let responseError = NetworkError.invalidResponse
                logError(message: "Network error occurred", error: responseError)
                fulfillHandlerOnTheMainThread(.failure(responseError))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let statusError = NetworkError.httpStatusCode(httpResponse.statusCode)
                logError(message: "Network error occurred", error: statusError)
                fulfillHandlerOnTheMainThread(.failure(statusError))
                return
            }

            guard let data = data else {
                let noDataError = NetworkError.noData
                logError(message: "Network error occurred", error: noDataError)
                fulfillHandlerOnTheMainThread(.failure(noDataError))
                return
            }

            fulfillHandlerOnTheMainThread(.success(data))
        }

        return task
    }
}
