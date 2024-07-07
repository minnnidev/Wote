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
    
    private let authUseCase: AuthUseCaseType

    init(authUseCase: AuthUseCaseType) {
        self.authUseCase = authUseCase
    }

    func send(action: Action) {
        switch action {

        case let .appleLogin(request):
            request.requestedScopes = []

        case let .appleLoginHandler(result):
            switch result {
            case let .success(authorization):
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
                print(String(data: credential.authorizationCode!, encoding: .utf8))
                // cf9ffa856f6e144be88587d9c5bd8027a.0.swzq.IKQRv9pp_U9vqb9bCTYL-g

            case let .failure(error):
                print(error.localizedDescription)
            }
            return
        }
    }
}
