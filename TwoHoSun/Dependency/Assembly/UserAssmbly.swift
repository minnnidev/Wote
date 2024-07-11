//
//  UserAssmbly.swift
//  TwoHoSun
//
//  Created by 김민 on 7/10/24.
//

import Foundation
import Swinject

final class UserAssmbly: Assembly {
    
    func assemble(container: Container) {

        container.register(SchoolSearchViewModel.self) { res in
            SchoolSearchViewModel(userUseCase: res.resolve(UserUseCaseType.self)!)
        }

        container.register(ProfileSettingViewModel.self) { res in
            ProfileSettingViewModel(userUseCase: res.resolve(UserUseCaseType.self)!)
        }

        container.register(UserUseCaseType.self) { res in
            UserUseCase(userRepository: res.resolve(UserRepositoryType.self)!)
        }

        container.register(UserRepositoryType.self) { res in
            UserRepository(userDataSource: res.resolve(UserDataSourceType.self)!)
        }

        container.register(UserDataSourceType.self) { _ in UserDataSource() }
    }
}
