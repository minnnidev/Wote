//
//  TypeTestUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 8/5/24.
//

import Foundation

protocol TypeTestUseCaseType {

}

final class TypeTestUseCase: TypeTestUseCaseType {

    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }

}

final class StubTypeTestUseCase: TypeTestUseCaseType {

}
