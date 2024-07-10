//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI
import AuthenticationServices
import Combine

final class LoginViewModel: ObservableObject {

    enum Action {
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginHandler(Result<ASAuthorization, Error>)
    }

    @Published var showSheet = false

    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false

    private let authUseCase: AuthUseCaseType

    private var cancellables = Set<AnyCancellable>()

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
                authUseCase.loginWithApple(authorization)
                    .sink { compeltion in
                        // TODO: completion: error
                    } receiveValue: { [weak self] authState in

                        guard authState == .notCompletedSetting else {
                            self?.isLoggedIn = true
                            return
                        }

                        self?.showSheet = true
                    }
                    .store(in: &cancellables)

            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
