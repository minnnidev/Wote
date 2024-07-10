//
//  CustomError.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import Foundation

enum WoteError: Error {
    case error(Error)
    case test
    case notCompletedSignUp(token: Tokens)
}

enum APIError: Error {
    case error(Error)
    case notCompletedSignUp(token: TokenObject)
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
