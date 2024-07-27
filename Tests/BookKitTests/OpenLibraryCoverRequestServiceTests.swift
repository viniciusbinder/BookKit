import XCTest
@testable import BookKit

class OpenLibraryCoverRequestServiceTests: XCTestCase {
    let service = OpenLibraryCoverRequestService()

    func testGetCoverURLSuccess() {
        do {
            let coverURL = try service.getCoverURL(bookId: "1")
            XCTAssertEqual(coverURL.absoluteString, "https://covers.openlibrary.org/b/isbn/1-M.jpg")
        } catch {
            XCTFail("Cover URL assembly failed with error: \(error)")
        }
    }

    func testGetCoverURLFailureInvalid() {
        XCTAssertThrowsError(try service.getCoverURL(bookId: "=")) { error in
            XCTAssertEqual(error as? CoverRequestError, CoverRequestError.invalidBookId)
        }
        XCTAssertThrowsError(try service.getCoverURL(bookId: "1 2")) { error in
            XCTAssertEqual(error as? CoverRequestError, CoverRequestError.invalidBookId)
        }
        XCTAssertThrowsError(try service.getCoverURL(bookId: "")) { error in
            XCTAssertEqual(error as? CoverRequestError, CoverRequestError.emptyBookId)
        }
    }

    func testChangeImageSizeSuccess() {
        do {
            let coverURL = try service.getCoverURL(bookId: "1")
            XCTAssertEqual(coverURL.absoluteString, "https://covers.openlibrary.org/b/isbn/1-M.jpg")
            service.imageSize = .small

            let smallCoverURL = try service.getCoverURL(bookId: "1")
            XCTAssertEqual(smallCoverURL.absoluteString, "https://covers.openlibrary.org/b/isbn/1-S.jpg")
            service.imageSize = .medium
        } catch {
            XCTFail("Cover URL assembly failed with error: \(error)")
        }
    }
}
