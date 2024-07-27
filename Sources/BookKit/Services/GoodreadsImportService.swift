//
//  GoodreadsImportService.swift
//  BookKit
//
//  Created by Vinícius on 26/07/24.
//

import Foundation

class GoodreadsImportService {
    private let parser = CSVParser()

    func parseBook(
        _ row: [String: String],
        attributesToInclude: [PartialKeyPath<Book>]
    ) throws -> Book {
        guard let id = row["Book Id"],
              let title = row["Title"],
              let author = row["Author"]
        else {
            throw BookImportError.missingRequiredFields
        }

        var attributes = optionalAttributeMap.filter { attributesToInclude.contains($0.key) }
        var book = Book(id: id, title: title, author: author)

        if let statusHeader = attributes[\.status] {
            book.status = parse(status: row[statusHeader] ?? "")
            attributes.removeValue(forKey: \.status)
        }

        if let dateReadHeader = attributes[\.dateRead] {
            book.dateRead = parse(dateRead: row[dateReadHeader] ?? "")
            attributes.removeValue(forKey: \.dateRead)
        }

        if let tagsHeader = attributes[\.tags] {
            book.tags = parse(tags: row[tagsHeader] ?? "")
            attributes.removeValue(forKey: \.tags)
        }

        attributes.forEach {
            if let writableKeyPath = $0.key as? WritableKeyPath<Book, String?> {
                book[keyPath: writableKeyPath] = row[$0.value]
            }
        }

        return book
    }

    private func parse(status: String) -> Book.Status {
        switch status {
        case "to-read": .WantToRead
        case "currently-reading": .CurrentlyReading
        case "read": .Read
        default: .WantToRead
        }
    }

    private func parse(dateRead: String) -> Date? {
        guard !dateRead.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: dateRead)
        return date
    }

    private func parse(tags: String) -> [String] {
        tags.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !["to-read", "currently-reading", "read"].contains($0) }
    }

    private var optionalAttributeMap: [PartialKeyPath<Book>: String] {
        [\.additionalAuthors: "Additional Authors", \.isbn: "ISBN", \.isbn13: "ISBN13", \.publisher: "Publisher", \.binding: "Binding", \.pages: "Number of Pages", \.published: "Year Published", \.firstPublished: "Original Publication Year", \.rating: "My Rating", \.dateRead: "Date Read", \.tags: "Bookshelves", \.status: "Exclusive Shelf", \.review: "My Review", \.readCount: "Read Count"]
    }
}

extension GoodreadsImportService: BookImportService {
    func importBooks(fileURL: URL?, attributesToInclude: [PartialKeyPath<Book>]) throws -> [Book] {
        guard let fileURL = fileURL else {
            throw BookImportError.fileURLRequired
        }

        let (headers, rows) = try parser.parse(fileURL: fileURL)
        let books = try rows.map { row in
            let matchedRow = Dictionary(uniqueKeysWithValues: zip(headers, row))
            return try parseBook(matchedRow, attributesToInclude: attributesToInclude)
        }

        return books
    }
}
