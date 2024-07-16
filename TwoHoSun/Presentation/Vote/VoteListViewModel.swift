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
        case calculateRatio(voteCount: Int, agreeCount: Int)
        case vote(selection: Bool)
    }

    @Published var isLoading: Bool = true
    @Published var currentVote: Int = 0
    @Published var votes: [VoteModel] = []
    @Published var agreeRatio: Double?
    @Published var disagreeRatio: Double?
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

            voteUseCase.loadVotes(page: 0, size: 5, scope: .global)
                .sink { [weak self] completion in
                    self?.isLoading = false
                } receiveValue: { [weak self] votes in
                    self?.isLoading = false
                    self?.votes = votes
                }
                .store(in: &cancellables)

        case .loadMoreVotes:
            page += 1

            voteUseCase.loadVotes(page: page, size: 5, scope: .global)
                .sink { _ in
                } receiveValue: { [weak self] votes in
                    self?.votes.append(contentsOf: votes)
                }
                .store(in: &cancellables)

        case let .calculateRatio(voteCounts, agreeCount):
            (agreeRatio, disagreeRatio) = calculatVoteRatio(voteCounts: voteCounts, agreeCount: agreeCount)

        case let .vote(selection):
            // TODO: 투표하기 API 연동
            return
        }
    }

    func calculatVoteRatio(voteCounts: Int, agreeCount: Int) -> (agree: Double, disagree: Double) {
        guard voteCounts != 0 else { return (0, 0) }

        let agreeRatio = Double(agreeCount) / Double(voteCounts) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
