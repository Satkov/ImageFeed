import UIKit

protocol RequestCacheManagerProtocol: AnyObject {
    func isDuplicateRequest(for key: String, identifier: String) -> Bool
    func isRepeatingIdentifier(for key: String, identifier: String) -> Bool
    func setActiveTask(_ task: URLSessionTask?, for key: String, with identifier: String)
    func cancelTask(for key: String)
}
