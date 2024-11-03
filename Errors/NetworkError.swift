enum NetworkError: Error {
    case httpStatusCode(Int)
    case responseError(String)
    case invalidResponse
    case noData
    case invalidRequest
}
