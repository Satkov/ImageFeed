import Foundation

extension Date {
    var dateString: String { DateFormatter.defaultDate.string(from: self) }
}

private extension DateFormatter {
    static let defaultDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = .init(identifier: "ru_RU")
        return formatter
    }()
}
