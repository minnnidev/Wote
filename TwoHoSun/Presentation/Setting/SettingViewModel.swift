//
//  SettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/22/23.
//

import Combine
import SwiftUI

final class SettingViewModel: ObservableObject {

    enum Action {
        case loadBlockUsers
        case unblockUser(memberId: Int)
        case logout(deviceToken: String)
        case withdraw
    }

    @Published var blockUsersList: [BlockedUserModel] = []

    private var cancellable = Set<AnyCancellable>()

    private let userUseCase: UserUseCaseType
    private let authUseCase: AuthUseCaseType

    init(userUseCase: UserUseCaseType, authUseCase: AuthUseCaseType) {
        self.userUseCase = userUseCase
        self.authUseCase = authUseCase
    }

    func send(action: Action) {
        switch action {
        case .loadBlockUsers:
            return

        case let .unblockUser(memberId):
            // TODO: 차단 해제 API 연결
            return

        case .logout(let deviceToken):
            // TODO: 로그아웃 API 연결
            return

        case .withdraw:
            // TODO: 회원 탈퇴 API 연결
            return
        }
    }
}
