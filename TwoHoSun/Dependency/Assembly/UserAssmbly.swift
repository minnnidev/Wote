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

        // MARK:  ViewModels

        container.register(SchoolSearchViewModel.self) { res in
            SchoolSearchViewModel(userUseCase: res.resolve(UserUseCaseType.self)!)
        }

        container.register(ProfileSettingViewModel.self) { res in
            ProfileSettingViewModel(
                userUseCase: res.resolve(UserUseCaseType.self)!,
                photoUseCase: res.resolve(PhotoUseCaseType.self)!
            )
        }

        container.register(MyPageViewModel.self) { res in
            MyPageViewModel(
                myPageUseCase: res.resolve(MyPageUseCaseType.self)!
            )
        }

        container.register(ProfileModifyViewModel.self) { res in
            ProfileModifyViewModel(
                userUseCase: res.resolve(UserUseCaseType.self)!,
                photoUseCase: res.resolve(PhotoUseCaseType.self)!
            )
        }

        // MARK: UseCases

        container.register(UserUseCaseType.self) { res in
            UserUseCase(userRepository: res.resolve(UserRepositoryType.self)!)
        }

        container.register(PhotoUseCaseType.self) { _ in PhotoUseCase() }

        container.register(MyPageUseCaseType.self) { res in
            MyPageUseCase(userRepository: res.resolve(UserRepositoryType.self)!)
        }

        // MARK: Repositories

        container.register(UserRepositoryType.self) { res in
            UserRepository(userDataSource: res.resolve(UserDataSourceType.self)!)
        }

        // MARK: DataSources

        container.register(UserDataSourceType.self) { _ in
            UserDataSource(provider: NetworkProvider.shared)
        }
    }
}
