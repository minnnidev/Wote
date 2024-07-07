//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI
import AuthenticationServices

final class LoginViewModel: ObservableObject {

    enum Action {
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginHandler(Result<ASAuthorization, Error>)
    }

    @Published var showSheet = false

    func send(action: Action) {
        switch action {
        case let .appleLogin(request):
            return
        case let .appleLoginHandler(result):
            return
        }
    }
}
