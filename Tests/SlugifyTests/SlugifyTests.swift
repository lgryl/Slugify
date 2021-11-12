import XCTest
@testable import Slugify

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
        assert(slugifying: "a - b", resultsIn: "a-b")
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

    private func assert(
        slugifying input: String,
        resultsIn expectedOutput: String,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let output = Slugify.slugify(input)
        XCTAssertEqual(output, expectedOutput)
    }
}
