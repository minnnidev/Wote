//
//  DetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/21/23.
//

import Combine
import SwiftUI

final class DetailViewModel: ObservableObject {

    enum Action {
        case loadDetail
        case vote
        case deleteVote
        case closeVote
    }

    @Published var agreeTopConsumerTypes = [ConsumerType]()
    @Published var disagreeTopConsumerTypes = [ConsumerType]()

    @Published var comments: CommentsModel?
    @Published var voteDetail: VoteDetailModel?
    @Published var isVoteResultShowed: Bool = false
    @Published var isVoteConsumerTypeResultShowed: Bool = false
    @Published var agreeRatio: Double?
    @Published var disagreeRatio: Double?

    private let postId: Int
    private let voteUseCase: VoteUseCaseType

    init(postId: Int, voteUseCase: VoteUseCaseType) {
        self.postId = postId
        self.voteUseCase = voteUseCase
    }

    private var cancellables: Set<AnyCancellable> = []

    func send(action: Action) {
        switch action {
        case .loadDetail:
            voteUseCase.loadVoteDetail(postId: postId)
                .sink { completion in
                } receiveValue: { [weak self] voteDetail in
                    self?.voteDetail = voteDetail
                    self?.agreeRatio = voteDetail.post.getAgreeRatio()
                    self?.disagreeRatio = voteDetail.post.getDisagreeRatio()
                    self?.agreeTopConsumerTypes = voteDetail.agreeTopConsumers ?? []
                    self?.disagreeTopConsumerTypes = voteDetail.disagreeTopConsumers ?? []

                    if voteDetail.post.postStatus == "CLOSED" || voteDetail.post.myChoice != nil {
                        self?.isVoteResultShowed = true
                    }

                    if voteDetail.post.voteCount ?? 0 > 0 { self?.isVoteConsumerTypeResultShowed = true }
                }
                .store(in: &cancellables)

        case .vote:
            return

        case .deleteVote:
            return

        case .closeVote:
            return
        }
    }

    func calculatVoteRatio(voteCounts: VoteCountsModel?) -> (agree: Double, disagree: Double) {
        guard let voteCounts = voteCounts else { return (0.0, 0.0) }
        let voteCount = voteCounts.agreeCount + voteCounts.disagreeCount

        guard voteCount != 0 else { return (0, 0) }
        let agreeRatio = Double(voteCounts.agreeCount) / Double(voteCount) * 100
        return (agreeRatio, 100 - agreeRatio)
    }
}
