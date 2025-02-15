//
//  AuthAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/8/24.
//

import Foundation
import Swinject

final class AuthAssembly: Assembly {

    func assemble(container: Container) {
        container.register(LoginViewModel.self) { res in
            LoginViewModel(authUseCase: res.resolve(AuthUseCaseType.self)!)
        }

        container.register(AuthUseCaseType.self) { res in
            AuthUseCase(authRepository: res.resolve(AuthRepositoryType.self)!)
        }

        container.register(AuthRepositoryType.self) { res in
            AuthRepository(authDataSource: res.resolve(AuthDataSourceType.self)!)
        }

        container.register(AuthDataSourceType.self) { _ in
            AuthDataSource(provider: NetworkProvider.shared)
        }
    }
}
