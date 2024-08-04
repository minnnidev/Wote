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
        case unblockUser(memberId: Int, index: Int)
        case logout(deviceToken: String)
        case withdraw
    }

    @Published var blockUsersList: [BlockedUserModel] = []
    @Published var isLoading: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    private let userUseCase: UserUseCaseType
    private let authUseCase: AuthUseCaseType

    init(userUseCase: UserUseCaseType, authUseCase: AuthUseCaseType) {
        self.userUseCase = userUseCase
        self.authUseCase = authUseCase
    }

    func send(action: Action) {
        switch action {
        case .loadBlockUsers:
            isLoading = true
            userUseCase.loadBlockedUsers()
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] blockedUsers in
                    self?.blockUsersList = blockedUsers
                    self?.isLoading = false
                }
                .store(in: &cancellables)

        case let .unblockUser(memberId, idx):
            userUseCase.unblockUser(memberId)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.blockUsersList.remove(at: idx)
                }
                .store(in: &cancellables)

        case .logout(let deviceToken):
            // TODO: 로그아웃 API 연결
            return

        case .withdraw:
            // TODO: 회원 탈퇴 API 연결
            return
        }
    }
}
