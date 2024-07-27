//
//  CSVParser.swift
//  BookKit
//
//  Created by Vinícius on 23/07/24.
//

import Foundation
import os

enum CSVParserError: Error {
    case fileReadError
    case emptyFile
    case invalidDataFormat
}

class CSVParser {
    func parse(fileURL: URL) throws -> (headers: [String], rows: [[String]]) {
        do {
            let fileContents = try String(contentsOf: fileURL)
            return try parseCSV(fileContents)
        } catch {
            throw CSVParserError.fileReadError
        }
    }
    
    func parseCSV(_ csvString: String) throws -> (headers: [String], rows: [[String]]) {
        let csv = csvString.components(separatedBy: "\n").filter { !$0.isEmpty }
        guard let headerRow = csv.first else {
            throw CSVParserError.emptyFile
        }
        
        let headers = parseCSVRow(headerRow)
        let csvRows = csv.dropFirst()
        
        var rows: [[String]] = []
        for row in csvRows {
            let columns = parseCSVRow(row)
            if columns.count == headers.count {
                let trimmed = columns.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                rows.append(trimmed)
            } else {
                throw CSVParserError.invalidDataFormat
            }
        }
        
        return (headers, rows)
    }
    
    private func parseCSVRow(_ row: String) -> [String] {
        var columns: [String] = []
        var currentField = ""
        var insideQuotes = false
        
        for character in row {
            if character == "\"" {
                insideQuotes.toggle()
            } else if character == ",", !insideQuotes {
                columns.append(currentField)
                currentField = ""
            } else {
                currentField.append(character)
            }
        }
        columns.append(currentField)
        
        return columns
    }
}
