//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Combine
import SwiftUI

final class MyPageViewModel: ObservableObject {

    enum Action {
        case loadMyVotes
        case loadMyReviews
        case changeSelectedType(_ type: MyPageListType)
    }

    @Published var selectedMyPageListType = MyPageListType.myVote

    var profile: ProfileModel?
    var total = 0

    private var cacellabels: Set<AnyCancellable> = []

    private let myPageUseCase: MyPageUseCaseType

    init(myPageUseCase: MyPageUseCaseType) {
        self.myPageUseCase = myPageUseCase
    }

    func send(action: Action) {
        switch action {
        case .loadMyVotes:
            // TODO:
            return

        case .loadMyReviews:
            // TODO:
            return

        case let .changeSelectedType(type):
            selectedMyPageListType = type
        }
    }
}
