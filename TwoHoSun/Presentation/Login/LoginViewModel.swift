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

    @Published var showSheet: Bool = false
    @Published var isLoading: Bool = false

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
            isLoading = true

            switch result {
            case let .success(authorization):
                authUseCase.loginWithApple(authorization)
                    .sink { [weak self] completion in
                        // TODO: - wote error handling

                        self?.isLoading = false

                    } receiveValue: { [weak self] authState in

                        self?.isLoading = false

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
