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
    }

    @Published var isLoading: Bool = true
    @Published var currentVote: Int = 0
    @Published var votes: [VoteModel] = []
    @Published var error: NetworkError?

    private var isLastPage = false
    private var page = 0

    private let voteUseCase: VoteUseCaseType

    private var cancellables: Set<AnyCancellable> = []

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
            // TODO: 투표 게시글 더 불러오기
            return
        }
    }

    func fetchPosts(page: Int = 0,
                    size: Int = 5,
                    visibilityScope: VisibilityScopeType,
                    isFirstFetch: Bool = true,
                    isRefresh: Bool = false) {
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount
        
        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
