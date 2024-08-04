//
//  SettingAssembly.swift
//  TwoHoSun
//
//  Created by 김민 on 8/4/24.
//

import Foundation
import Swinject

final class SettingAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SettingViewModel.self) { res in
            SettingViewModel(
                userUseCase: res.resolve(UserUseCaseType.self)!,
                authUseCase: res.resolve(AuthUseCaseType.self)!
            )
        }
    }
}
