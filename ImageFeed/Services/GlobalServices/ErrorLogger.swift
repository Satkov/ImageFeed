func logError(message: String, error: Error? = nil) {
    print("LOG: \(message): \(error?.localizedDescription ?? "")")
}
