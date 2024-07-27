import XCTest
@testable import BookKit

class BookImportManagerTests: XCTestCase {
    let manager = BookImportManager(service: GoodreadsImportService(), attributesToInclude: [\.status])
    
    func testImportBooksFileSuccess() {
        let fileURL = Bundle.module.url(forResource: "GoodreadsSampleFile", withExtension: "csv")!
        
        func assertBook(_ book: Book, id: String, title: String, author: String, status: Book.Status) {
            XCTAssertEqual(book.id, id)
            XCTAssertEqual(book.title, title)
            XCTAssertEqual(book.author, author)
            XCTAssertEqual(book.status, status)
        }
        
        do {
            let books = try manager.importBooks(fileURL: fileURL)

            assertBook(books[0], id: "52717097", title: "My Brilliant Friend (The Neapolitan Novels, #1)",
                       author: "Elena Ferrante", status: .WantToRead)
            assertBook(books[1], id: "133938826", title: "Welcome to the Hyunam-dong Bookshop",
                       author: "Hwang Bo-Reum", status: .CurrentlyReading)
            assertBook(books[2], id: "6495110", title: "The True Deceiver",
                       author: "Tove Jansson", status: .Read)
        } catch {
            XCTFail("Import failed with error: \(error)")
        }
    }
    
    func testImportBooksFileFailure() {
        XCTAssertThrowsError(try manager.importBooks(fileURL: nil)) { error in
            XCTAssertEqual(error as? BookImportError, BookImportError.fileURLRequired)
        }
    }
}
