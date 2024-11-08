import Foundation

final class RequestCacheManager {

    static let shared = RequestCacheManager()

    private var activeTasks: [String: URLSessionTask] = [:]
    private var taskIdentifiers: [String: String] = [:]
    private var previousIdentifiers: [String: String] = [:]

    private init() {}

    // MARK: - Request Checks

    /// Проверяет, является ли запрос дубликатом для указанного ключа и идентификатора
    func isDuplicateRequest(for key: String, identifier: String) -> Bool {
        return activeTasks[key] != nil && taskIdentifiers[key] == identifier
    }

    /// Проверяет, совпадает ли последний идентификатор с текущим
    func isRepeatingIdentifier(for key: String, identifier: String) -> Bool {
        return previousIdentifiers[key] == identifier
    }

    // MARK: - Task Management

    /// Сохраняет активную задачу и её идентификатор в кэш
    func setActiveTask(_ task: URLSessionTask?, for key: String, with identifier: String) {
        if let task = task {
            activeTasks[key] = task
            taskIdentifiers[key] = identifier
            previousIdentifiers[key] = identifier
        } else {
            activeTasks[key] = nil
            taskIdentifiers[key] = nil
        }
    }

    /// Отменяет и удаляет активную задачу для указанного ключа
    func cancelTask(for key: String) {
        activeTasks[key]?.cancel()
        activeTasks[key] = nil
        taskIdentifiers[key] = nil
    }
}
