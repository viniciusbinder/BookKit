//
//  Book.swift
//  BookKit
//
//  Created by Vinícius on 23/07/24.
//

import Foundation

class Book: Identifiable {
    private(set) var id: String
    private(set) var title: String
    private(set) var author: String

    var additionalAuthors: String?
    var isbn: String?
    var isbn13: String?
    var publisher: String?
    var binding: String?
    var pages: String?
    var published: String?
    var firstPublished: String?
    var rating: String?
    var review: String?
    var readCount: String?

    var dateRead: Date?
    var tags: [String]?
    var status: Status?

    enum Status {
        case WantToRead
        case CurrentlyReading
        case Read
    }

    required init(
        id: String,
        title: String,
        author: String,
        additionalAuthors: String? = nil,
        isbn: String? = nil,
        isbn13: String? = nil,
        publisher: String? = nil,
        binding: String? = nil,
        pages: String? = nil,
        published: String? = nil,
        firstPublished: String? = nil,
        rating: String? = nil,
        review: String? = nil,
        readCount: String? = nil,
        dateRead: Date? = nil,
        tags: [String]? = nil,
        status: Status? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.additionalAuthors = additionalAuthors
        self.isbn = isbn
        self.isbn13 = isbn13
        self.publisher = publisher
        self.binding = binding
        self.pages = pages
        self.published = published
        self.firstPublished = firstPublished
        self.rating = rating
        self.review = review
        self.readCount = readCount
        self.dateRead = dateRead
        self.tags = tags
        self.status = status
    }
}

extension Book: Equatable {
    public static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
}

extension Book {
    public static var allOptionalAttributes: [PartialKeyPath<Book>] {
        [
            \.additionalAuthors,
            \.isbn,
            \.isbn13,
            \.publisher,
            \.binding,
            \.pages,
            \.published,
            \.firstPublished,
            \.rating,
            \.review,
            \.readCount,
            \.dateRead,
            \.tags,
            \.status
        ]
    }
}
