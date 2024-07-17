//
//  VoteListViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class VoteListViewModel: ObservableObject {

    enum Action {
        case loadVotes
        case loadMoreVotes
        case vote(selection: Bool)
    }

    @Published var isLoading: Bool = true
    @Published var currentVote: Int = 0
    @Published var votes: [VoteModel] = []
    @Published var visibilityScope: VisibilityScopeType = .global

    private var cancellables: Set<AnyCancellable> = []
    private var page: Int = 0

    private let voteUseCase: VoteUseCaseType

    init(voteUseCase: VoteUseCaseType) {
        self.voteUseCase = voteUseCase
    }

    func send(action: Action) {
        switch action {
        case .loadVotes:
            isLoading = true

            voteUseCase.loadVotes(page: 0, size: 10, scope: .global)
                .sink { [weak self] completion in
                    self?.isLoading = false
                } receiveValue: { [weak self] votes in
                    self?.isLoading = false
                    self?.votes = votes
                }
                .store(in: &cancellables)

        case .loadMoreVotes:
            page += 1

            voteUseCase.loadVotes(page: page, size: 10, scope: .global)
                .sink { _ in
                } receiveValue: { [weak self] votes in
                    self?.votes.append(contentsOf: votes)
                }
                .store(in: &cancellables)

        case let .vote(selection):
            let postId = votes[currentVote].id
            let voteCount = votes[currentVote].voteCount ?? 0

            voteUseCase.vote(postId: postId, myChoice: selection)
                .sink { _ in
                    // TODO: - 투표하기 실패 alert
                } receiveValue: { [weak self] (agreeRatio, disagreeRatio) in
                    guard let self = self else { return }

                    votes[currentVote].agreeRatio = agreeRatio
                    votes[currentVote].disagreeRatio = disagreeRatio
                    
                    votes[currentVote].myChoice = selection
                    votes[currentVote].voteCount = voteCount + 1
                }
                .store(in: &cancellables)
        }
    }
}
