//
//  User.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation

struct User {
    let authenticationState: AuthenticationState
    let tokens: Tokens
}

enum AuthenticationState {
    case unauthenticated
    case notCompletedSetting
    case authenticated
}
