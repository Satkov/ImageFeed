extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) {
        guard indices.contains(index) else { return }
        self[index] = newValue
    }
}
