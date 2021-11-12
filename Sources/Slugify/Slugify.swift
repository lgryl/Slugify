import Foundation

private struct Slugify {
    private init() {}

    internal static func slugify(_ string: String) -> String {
        string
            .lowercased()
            .removingDiacritics()
            .removingCharacters()
            .trimmed()
            .reducingWhitespaces()
            .hyphenazingSpaces()
            .reducingHyphens()
    }
}

public extension String {
    var slug: String {
        Slugify.slugify(self)
    }
}

private extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func reducingWhitespaces() -> String {
        replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
    }
    func hyphenazingSpaces() -> String {
        replacingOccurrences(of: " ", with: "-")
    }
    func removingDiacritics() -> String {
        let folded = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
        let result = folded.replacingOccurrences(of: "ł", with: "l")
        return result
    }
    func removingCharacters() -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.formUnion(.whitespacesAndNewlines)
        characterSet.insert("-")
        let characters = filter { (c) -> Bool in
            return !c.unicodeScalars.contains(where: { !characterSet.contains($0)})
        }
        return String(characters)
    }

    func reducingHyphens() -> String {
        replacingOccurrences(of: #"-+"#, with: "-", options: .regularExpression)
    }
}
