//
//  BookImportService.swift
//  BookKit
//
//  Created by Vinícius on 23/07/24.
//

import Foundation

public enum BookImportError: Error {
    case fileURLRequired
    case missingRequiredFields
}

public protocol BookImportService {
    func importBooks(fileURL: URL?, attributesToInclude: [PartialKeyPath<Book>]) throws -> [Book]
}
