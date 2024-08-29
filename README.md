# BookKit
BookKit is a concise Swift package that offers a `Book` entity for out-of-the-box or DTO usage, and protocols for implementing services to import library data and retrieve book covers. Included are two service implementations for importing library data from _Goodreads_ and requesting covers from the _OpenLibrary_ API.

## Usage

BookKit has two main protocols: `BookImportService` and `CoverRequestService`. Below are the two included service implementations with these protocols and how to use them in your app.

#### Importing Book Data
Using the `BookImportManager` along with a `BookImportService` implementation that integrates with Goodreads.

```Swift
let importService = GoodreadsImportService()
let attributesToInclude = Book.allOptionalAttributes
let importManager = BookImportManager(service: importService, attributesToInclude: attributesToInclude)

let fileURL = Bundle.module.url(forResource: "GoodreadsLibraryExportFile", withExtension: "csv")!
let books = try? importManager.importBooks(fileURL: fileURL)
```

#### Requesting Book Covers
Using a `CoverRequestService` implementation that integrates with OpenLibrary.

```Swift
let coverService = OpenLibraryCoverRequestService(imageSize: .small)
let coverURL = try coverService.getCoverURL(bookId: bookId)
```


## License
BookKit is available under the MIT license. See LICENSE for more information.

## Swift Package Index
Available through SPI: [https://swiftpackageindex.com/viniciusbinder/BookKit](https://swiftpackageindex.com/viniciusbinder/BookKit).
