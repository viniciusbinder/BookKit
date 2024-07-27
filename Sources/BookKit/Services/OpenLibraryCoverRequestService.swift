//
//  File.swift
//
//
//  Created by Vinícius on 26/07/24.
//

import Foundation

class OpenLibraryCoverRequestService {
    var imageSize: ImageSize

    enum ImageSize: String {
        case small = "S"
        case medium = "M"
        case large = "L"
    }

    init(imageSize: ImageSize = .medium) {
        self.imageSize = imageSize
    }
}

extension OpenLibraryCoverRequestService: CoverRequestService {
    private static let coversAPI = "https://covers.openlibrary.org/b/isbn/"

    func getCoverURL(bookId: String) throws -> URL {
        guard !bookId.isEmpty else {
            throw CoverRequestError.emptyBookId
        }
        guard bookId.reduce(true, { $0 && $1.isNumber }) else {
            throw CoverRequestError.invalidBookId
        }

        let string = Self.coversAPI + bookId + "-" + imageSize.rawValue + ".jpg"
        guard let url = URL(string: string) else {
            // This will never throw since `coversAPI` is configured correctly
            throw CoverRequestError.invalidCoverURL
        }

        return url
    }
}
