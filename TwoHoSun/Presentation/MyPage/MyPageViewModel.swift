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

    @Published var selectedMyPageListType: MyPageListType = .myVote
    @Published var isLoading: Bool = false
    @Published var myVotes: [MyVoteModel] = .init()
    @Published var totalVotes: Int = 0


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
            isLoading = true

            myPageUseCase.getMyVotes(page: 0, size: 10)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] votes in
                    self?.myVotes = votes.votes
                    self?.totalVotes = votes.total
                    self?.isLoading = false
                }
                .store(in: &cacellabels)

        case .loadMyReviews:
            // TODO:
            return

        case let .changeSelectedType(type):
            selectedMyPageListType = type
        }
    }
}
