//
//  WoteError.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import Foundation

enum WoteError: Error, LocalizedError {
    case error(Error)
    case notCompletedSignUp(token: Tokens)
    case authenticateFailed 

    var errorDescription: String? {
        switch self {
        case .error(_):
            "알 수 없는 오류가 발생했습니다."
        case .notCompletedSignUp(_):
            "회원가입이 완료되지 않았습니다."
        case .authenticateFailed:
            "로그인에 실패하였습니다.\n 잠시 후 다시 시도해 주세요."
        }
    }
}
