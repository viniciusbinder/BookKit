//
//  Book.swift
//  BookKit
//
//  Created by Vinícius on 23/07/24.
//

import Foundation

open class Book: Identifiable, Codable {
    public var id: String
    public var title: String
    public var author: String

    public var additionalAuthors: String?
    public var isbn: String?
    public var isbn13: String?
    public var publisher: String?
    public var binding: String?
    public var pages: String?
    public var published: String?
    public var firstPublished: String?
    public var rating: String?
    public var review: String?
    public var readCount: String?

    public var dateRead: Date?
    public var tags: [String]?
    public var status: Status?

    public enum Status: String, CaseIterable, Codable {
        case WantToRead
        case CurrentlyReading
        case Read
    }

    public required init(
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

extension Book: Equatable {
    public static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
}
