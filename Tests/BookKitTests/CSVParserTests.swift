import XCTest
@testable import BookKit

class CSVParserTests: XCTestCase {
    var parser: CSVParser!
    
    override func setUp() {
        super.setUp()
        parser = CSVParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    func testParseCSVSuccess() {
        let csvString = """
        header1,header2,header3
        value1,value2,value3
        value4,value5,value6
        """
        
        do {
            let (headers, rows) = try parser.parseCSV(csvString)
            XCTAssertEqual(headers, ["header1", "header2", "header3"])
            XCTAssertEqual(rows, [["value1", "value2", "value3"], ["value4", "value5", "value6"]])
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseCSVFailureMissingHeader() {
        let csvString = """
        """
        
        XCTAssertThrowsError(try parser.parseCSV(csvString)) { error in
            XCTAssertEqual(error as? CSVParserError, CSVParserError.emptyFile)
        }
    }
    
    func testParseCSVFailureInvalidDataFormat() {
        let csvString = """
        header1,header2,header3
        value1,value2
        value4,value5,value6
        """
        
        XCTAssertThrowsError(try parser.parseCSV(csvString)) { error in
            XCTAssertEqual(error as? CSVParserError, CSVParserError.invalidDataFormat)
        }
    }
    
    func testParseFileSuccess() {
        let fileURL = Bundle.module.url(forResource: "CSVTestFile", withExtension: "csv")!
        
        do {
            let (headers, rows) = try parser.parse(fileURL: fileURL)
            XCTAssertEqual(headers, ["header1", "header2", "header3"])
            XCTAssertEqual(rows, [["value1", "value2", "value3"], ["value4", "value5", "value6"]])
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseFileFailure() {
        let fileURL = URL(fileURLWithPath: "/invalid/path/to/file.csv")
        
        XCTAssertThrowsError(try parser.parse(fileURL: fileURL)) { error in
            XCTAssertEqual(error as? CSVParserError, CSVParserError.fileReadError)
        }
    }
}
