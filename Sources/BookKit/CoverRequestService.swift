//
//  CoverRequestService.swift
//  BookKit
//
//  Created by Vinícius on 26/07/24.
//

import Foundation

public enum CoverRequestError: Error {
    case invalidCoverURL
    case emptyBookId
    case invalidBookId
}

public protocol CoverRequestService {
    func getCoverURL(bookId: String) throws -> URL
}
