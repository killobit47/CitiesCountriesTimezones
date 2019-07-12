//
//  TimeZoneError.swift
//
//  Created by Roman Ganzha on 11/30/18.
//

import Foundation

enum TimeZoneError: Error {
    case jsonSerialization
    case fileNotExist
    case invalidJson
}

extension TimeZoneError {
    var errorMessage: String {
        return self.errorDescription ?? ""
    }
}

// MARK: - LocalizedError

extension TimeZoneError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .jsonSerialization, .invalidJson:
            return "Unexpected JSON format.".localized
        case .fileNotExist:
            return "json file not exist".localized
        }
    }
}
