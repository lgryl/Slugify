import XCTest
import Slugify

final class SlugifyTests: XCTestCase {
    func test_givenEmptyString_returnsEmptyString() {
        assert(slugifying: "", resultsIn: "")
    }

    func test_givenSpace_returnsEmptyString() {
        assert(slugifying: " ", resultsIn: "")
    }

    func test_givenMultipleSpace_returnsEmptyString() {
        assert(slugifying: "   ", resultsIn: "")
    }

    func test_givenStringWithEnglishCharacters_returnsThatString() {
        assert(slugifying: "abc", resultsIn: "abc")
    }

    func test_givenUppercaseString_returnsLowercaseString() {
        assert(slugifying: "ABC", resultsIn: "abc")
    }

    func test_givenStringWithEnglishCharactersAndLeadingSpaces_removesLeadingSpaces() {
        assert(slugifying: "  abc", resultsIn: "abc")
    }

    func test_givenStringWithEnglishCharactersAndTrailingSpaces_removesTrailingSpaces() {
        assert(slugifying: "abc  ", resultsIn: "abc")
    }

    func test_givenStringWithEnglishCharactersAndLeadingAndTrailingSpaces_trimsString() {
        assert(slugifying: "   abc  ", resultsIn: "abc")
    }

    func test_givenStringWithSpaceInTheMiddle_changesSpaceToHyphen() {
        assert(slugifying: "a b", resultsIn: "a-b")
    }

    func test_givenStringWithSpacesInTheMiddle_changesSpaceToHyphen() {
        assert(slugifying: "a   b", resultsIn: "a-b")
    }

    func test_digits_dontChange() {
        assert(slugifying: "1234567890", resultsIn: "1234567890")
    }

    func test_leadingHyphen_isNotRemoved() {
        assert(slugifying: "-ab", resultsIn: "-ab")
    }

    func test_trailingHyphen_isNotRemoved() {
        assert(slugifying: "ab-", resultsIn: "ab-")
    }

    func test_leadingHyphens_getReduced() {
        assert(slugifying: "---ab", resultsIn: "-ab")
    }

    func test_trailingHyphens_getReduced() {
        assert(slugifying: "ab----", resultsIn: "ab-")
    }

    func test_hyphensInTheMiddle_getReduced() {
        assert(slugifying: "a--b", resultsIn: "a-b")
    }

    func test_hyphenWithSpaces_getReducedToHyphen() {
        assert(slugifying: "a - -- b", resultsIn: "a-b")
    }

    func test_leadingHyphenWithSpaces_getReducedToHyphen() {
        assert(slugifying: " -  - -ab", resultsIn: "-ab")
    }

    func test_trailingHyphenWithSpaces_getReducedToHyphen() {
        assert(slugifying: "ab -  - -", resultsIn: "ab-")
    }

    func test_givenMultilineString_convertsNewLineToHyphen() {
        let multilineString = """
        aaa
        bbb
        """
        assert(slugifying: multilineString, resultsIn: "aaa-bbb")
    }

    func test_givenMultilineString_trimsStringOfNewLines() {
        let multilineString = """

        aaa

        """
        assert(slugifying: multilineString, resultsIn: "aaa")
    }

    func test_givenStringWithPolishDiactrics_changesDiactricsToEnglishCounterparts() {
        assert(slugifying: "ąćęłńóśźż", resultsIn: "acelnoszz")
        assert(slugifying: "ĄĆĘŁŃÓŚŹŻ", resultsIn: "acelnoszz")
    }

    func test_givenStringWithFrenchDiactrics_changesDiactricsToEnglishCounterparts() {
        assert(slugifying: "çéâêîôûàèìòùëïü", resultsIn: "ceaeiouaeioueiu")
        assert(slugifying: "ÇÉÂÊÎÔÛÀÈÌÒÙËÏÜ", resultsIn: "ceaeiouaeioueiu")
    }

    func test_givenStringWithGermanDiactrics_changesDiactricsToEnglishCounterparts() {
        assert(slugifying: "äöüß", resultsIn: "aouss")
        assert(slugifying: "ÄÖÜẞ", resultsIn: "aouss")
    }

    func test_givenEmoji_returnsEmptyString() {
        assert(slugifying: "😀", resultsIn: "")
    }

    func test_stringWithInvalidCharacters_invalidCharactersAreRemoved() {
        assert(slugifying: "£§!@#$%^&*()_=+[]{};:'\"\\<>,./?", resultsIn: "")
    }

    func test_leadingInvalidCharacters_areRemoved() {
        assert(slugifying: "?a", resultsIn: "a")
    }

    func test_trailingInvalidCharacters_areRemoved() {
        assert(slugifying: "a?", resultsIn: "a")
    }

    func test_invalidCharactersInTheMiddle_areRemoved() {
        assert(slugifying: "a??b", resultsIn: "ab")
    }

    func test_leadingInvalidCharactersWithSpaces_areRemoved() {
        assert(slugifying: " ? ?a", resultsIn: "a")
    }

    func test_trailingInvalidCharactersWithSpaces_areRemoved() {
        assert(slugifying: "a? ?", resultsIn: "a")
    }

    func test_invalidCharactersInTheMiddleWithSpaces_areRemoved() {
        assert(slugifying: "a ?  ?b", resultsIn: "a-b")
    }

    func test_englishSentences_getSlugifiedCorrectly() {
        assert(
            slugifying: "We know what we are, but know not what we may be.",
            resultsIn: "we-know-what-we-are-but-know-not-what-we-may-be"
        )
    }

    func test_polishSentences_getSlugifiedCorrectly() {
        assert(
            slugifying: "Zażółć gęślą jaźń",
            resultsIn: "zazolc-gesla-jazn"
        )
    }

    func test_frenchSentences_getSlugifiedCorrectly() {
        assert(
            slugifying: "À vaillant coeur rien d’impossible",
            resultsIn: "a-vaillant-coeur-rien-dimpossible"
        )
    }

    private func assert(
        slugifying input: String,
        resultsIn expectedOutput: String,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let output = input.slug
        XCTAssertEqual(output, expectedOutput)
    }
}
