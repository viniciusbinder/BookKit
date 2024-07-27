import XCTest
@testable import BookKit

class GoodreadsImportServiceTests: XCTestCase {
    var service: GoodreadsImportService!
    
    override func setUp() {
        super.setUp()
        service = GoodreadsImportService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testParseBookSuccess() {
        let headers = ["Book Id", "Title", "Author", "Author l-f", "Additional Authors", "ISBN", "ISBN13", "My Rating", "Average Rating", "Publisher", "Binding", "Number of Pages", "Year Published", "Original Publication Year", "Date Read", "Date Added", "Bookshelves", "Bookshelves with positions", "Exclusive Shelf", "My Review", "Spoiler", "Private Notes", "Read Count", "Owned Copies"]
        let row = ["52717097", "My Brilliant Friend (The Neapolitan Novels, #1)", "Elena Ferrante", "Ferrante, Elena", "Ann Goldstein", "=", "=9781787702226", "0", "4.04", "Europa Editions", "Paperback", "331", "2020", "2011", "", "2024/07/18", "to-read", "to-read (#78)", "to-read", "", "", "", "0", "0"]
        
        do {
            let matchedRow = Dictionary(uniqueKeysWithValues: zip(headers, row))
            let book = try service.parseBook(matchedRow, attributesToInclude: [])
            
            XCTAssertEqual(book.id, "52717097")
            XCTAssertEqual(book.title, "My Brilliant Friend (The Neapolitan Novels, #1)")
            XCTAssertEqual(book.author, "Elena Ferrante")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseBookAllAttributesSuccess() {
        let headers = ["Book Id", "Title", "Author", "Author l-f", "Additional Authors", "ISBN", "ISBN13", "My Rating", "Average Rating", "Publisher", "Binding", "Number of Pages", "Year Published", "Original Publication Year", "Date Read", "Date Added", "Bookshelves", "Bookshelves with positions", "Exclusive Shelf", "My Review", "Spoiler", "Private Notes", "Read Count", "Owned Copies"]
        let row = ["52717097", "My Brilliant Friend (The Neapolitan Novels, #1)", "Elena Ferrante", "Ferrante, Elena", "Ann Goldstein", "=", "=9781787702226", "0", "4.04", "Europa Editions", "Paperback", "331", "2020", "2011", "", "2024/07/18", "to-read", "to-read (#78)", "to-read", "", "", "", "0", "0"]
        
        do {
            let matchedRow = Dictionary(uniqueKeysWithValues: zip(headers, row))
            let book = try service.parseBook(matchedRow, attributesToInclude: Book.allOptionalAttributes)
            
            XCTAssertEqual(book.id, "52717097")
            XCTAssertEqual(book.title, "My Brilliant Friend (The Neapolitan Novels, #1)")
            XCTAssertEqual(book.author, "Elena Ferrante")
            
            XCTAssertEqual(book.additionalAuthors, "Ann Goldstein")
            XCTAssertEqual(book.isbn, "=")
            XCTAssertEqual(book.isbn13, "=9781787702226")
            XCTAssertEqual(book.publisher, "Europa Editions")
            XCTAssertEqual(book.binding, "Paperback")
            XCTAssertEqual(book.pages, "331")
            XCTAssertEqual(book.published, "2020")
            XCTAssertEqual(book.firstPublished, "2011")
            XCTAssertEqual(book.rating, "0")
            XCTAssertEqual(book.review, "")
            XCTAssertEqual(book.readCount, "0")
            
            XCTAssertEqual(book.dateRead, nil)
            XCTAssertEqual(book.tags, [])
            XCTAssertEqual(book.status, .WantToRead)
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testParseBookFailureMissingRequiredFields() {
        // Missing "Author" header
        let headers = ["Book Id", "Title", "Author l-f", "Additional Authors", "ISBN", "ISBN13", "My Rating", "Average Rating", "Publisher", "Binding", "Number of Pages", "Year Published", "Original Publication Year", "Date Read", "Date Added", "Bookshelves", "Bookshelves with positions", "Exclusive Shelf", "My Review", "Spoiler", "Private Notes", "Read Count", "Owned Copies"]
        let row = ["52717097", "My Brilliant Friend (The Neapolitan Novels, #1)", "Elena Ferrante", "Ferrante, Elena", "Ann Goldstein", "=", "=9781787702226", "0", "4.04", "Europa Editions", "Paperback", "331", "2020", "2011", "", "2024/07/18", "to-read", "to-read (#78)", "to-read", "", "", "", "0", "0"]

        let matchedRow = Dictionary(uniqueKeysWithValues: zip(headers, row))
        XCTAssertThrowsError(try service.parseBook(matchedRow, attributesToInclude: [])) { error in
            XCTAssertEqual(error as? BookImportError, BookImportError.missingRequiredFields)
        }
    }
    
    func testImportBooksFileSuccess() {
        let fileURL = Bundle.module.url(forResource: "GoodreadsSampleFile", withExtension: "csv")!
        let attributesToInclude = [\Book.status]
        
        func assertBook(_ book: Book, id: String, title: String, author: String, status: Book.Status) {
            XCTAssertEqual(book.id, id)
            XCTAssertEqual(book.title, title)
            XCTAssertEqual(book.author, author)
            XCTAssertEqual(book.status, status)
        }
        
        do {
            let books = try service.importBooks(fileURL: fileURL, attributesToInclude: attributesToInclude)
            
            assertBook(books[0], id: "52717097", title: "My Brilliant Friend (The Neapolitan Novels, #1)", author: "Elena Ferrante", status: .WantToRead)
            assertBook(books[1], id: "133938826", title: "Welcome to the Hyunam-dong Bookshop", author: "Hwang Bo-Reum", status: .CurrentlyReading)
            assertBook(books[2], id: "6495110", title: "The True Deceiver", author: "Tove Jansson", status: .Read)
        } catch {
            XCTFail("Import failed with error: \(error)")
        }
    }
    
    func testImportBooksFileFailure() {
        XCTAssertThrowsError(try service.importBooks(fileURL: nil, attributesToInclude: [])) { error in
            XCTAssertEqual(error as? BookImportError, BookImportError.fileURLRequired)
        }
    }
}
