//
//  BookImportManager.swift
//  BookKit
//
//  Created by Vinícius on 23/07/24.
//

import Foundation

class BookImportManager {
    private var importService: BookImportService
    private var attributesToInclude: [PartialKeyPath<Book>]

    init(service: BookImportService, attributesToInclude: [PartialKeyPath<Book>]) {
        self.importService = service
        self.attributesToInclude = attributesToInclude
    }

    convenience init(service: BookImportService) {
        self.init(service: service, attributesToInclude: Book.allOptionalAttributes)
    }

    func importBooks(fileURL: URL?) throws -> [Book] {
        return try importService.importBooks(fileURL: fileURL, attributesToInclude: attributesToInclude)
    }
}
