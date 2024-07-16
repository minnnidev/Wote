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

    private func setTopConsumerTypes() {
        guard let voteInfoList = voteDetail?.post.voteInfoList else { return }
        let (agreeVoteInfos, disagreeVoteInfos) = filterSelectedResult(voteInfoList: voteInfoList)
        agreeTopConsumerTypes = getTopConsumerTypes(for: agreeVoteInfos)
        disagreeTopConsumerTypes = getTopConsumerTypes(for: disagreeVoteInfos)
    }

    private func filterSelectedResult(voteInfoList: [VoteInfoModel]) -> (agree: [VoteInfoModel],
                                                                disagree: [VoteInfoModel]) {
        return (voteInfoList.filter { $0.isAgree }, voteInfoList.filter { !$0.isAgree })
    }

    private func getTopConsumerTypes(for votes: [VoteInfoModel]) -> [ConsumerType] {
        return Dictionary(grouping: votes, by: { $0.consumerType })
            .sorted { $0.value.count > $1.value.count }
            .prefix(2)
            .map { ConsumerType(rawValue: $0.key) }
            .compactMap { $0 }
    }
}
