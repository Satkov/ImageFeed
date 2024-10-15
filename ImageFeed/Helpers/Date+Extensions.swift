import Foundation

extension Date {
    var dateTimeString: String { DateFormatter.defaultDateTime.string(from: self) }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = .init(identifier: "ru_RU")
        return formatter

    }()
}
