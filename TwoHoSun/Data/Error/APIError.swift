//
//  APIError.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation

enum APIError: Error {
    case error(Error)
    case moyaError(Error)
    case notCompletedSignUp(token: TokenObject)
    case decodingError
    case unknownError

    init(divisionCode: String, tokenObject: TokenObject? = nil) {
        switch divisionCode {
        case "E009":
            if let tokenObject = tokenObject {
                self = .notCompletedSignUp(token: tokenObject)
            } else {
                self = .unknownError
            }

        default:
            self = .unknownError
        }
    }
}
