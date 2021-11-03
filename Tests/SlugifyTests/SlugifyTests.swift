import XCTest
@testable import Slugify

final class SlugifyTests: XCTestCase {
    func test() throws {
        let slug = Slugify.slugify("foo")
        XCTAssertEqual("foo", slug)
    }
}
