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
        case logout
        case withdraw
    }

    @Published var blockUsersList: [BlockedUserModel] = []
    @Published var isLoading: Bool = false
    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false

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

        case .logout:
            let deviceToken = KeychainManager.shared.read(key: TokenType.deviceToken) ?? ""
            authUseCase.logout(deviceToken)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.isLoggedIn.toggle()
                }
                .store(in: &cancellables)

        case .withdraw:
            // TODO: 회원 탈퇴 API 연결 - keychain 삭제
            return
        }
    }
}
