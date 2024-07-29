//
//  ProfileModifyViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

final class ProfileModifyViewModel: ObservableObject {
    
    private let userUseCase: UserUseCaseType

    init(userUseCase: UserUseCaseType) {
        self.userUseCase = userUseCase
    }
}
