//
//  MyPageUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

protocol MyPageUseCaseType {

}

final class MyPageUseCase: MyPageUseCaseType {

    private let userRepository: UserRepositoryType

    init(userRepository: UserRepositoryType) {
        self.userRepository = userRepository
    }
}

final class StubMyPageUseCase: MyPageUseCaseType {

}
