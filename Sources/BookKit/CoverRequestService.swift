//
//  CoverRequestService.swift
//  BookKit
//
//  Created by Vinícius on 26/07/24.
//

import Foundation

enum CoverRequestError: Error {
    case invalidCoverURL
    case emptyBookId
    case invalidBookId
}

protocol CoverRequestService {
    func getCoverURL(bookId: String) throws -> URL
}
