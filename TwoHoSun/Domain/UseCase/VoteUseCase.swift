//
//  VoteUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Combine

protocol VoteUseCaseType {
    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError>
    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError>
    func vote(postId: Int, myChoice: Bool) -> AnyPublisher<(Double, Double), WoteError>
}

final class VoteUseCase: VoteUseCaseType {

    private let voteRepository: VoteRepositoryType

    init(voteRepository: VoteRepositoryType) {
        self.voteRepository = voteRepository
    }

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        voteRepository.getVotes(page: page, size: size, scope: scope)
            .map { [weak self] votes in
                guard let self = self else { return [] }

                return votes.map { self.mapVoteModelWithVoteRatio(from: $0) }
            }
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        voteRepository.getVoteDetail(postId: postId)
            .map { [weak self] vote in
                guard let self = self else { return vote }
                return self.mapVoteDetailModelWithResult(from: vote)
            }
            .eraseToAnyPublisher()
    }

    func vote(postId: Int, myChoice: Bool) -> AnyPublisher<(Double, Double), WoteError> {
        voteRepository.vote(postId: postId, myChoice: myChoice)
            .map{ voteCounts in
                let total = voteCounts.agreeCount + voteCounts.disagreeCount
                let agreeRatio = self.calculateRatio(for: voteCounts.agreeCount, totalCount: total)
                let disagreeRatio = self.calculateRatio(for: voteCounts.disagreeCount, totalCount: total)

                return (agreeRatio, disagreeRatio)
            }
            .eraseToAnyPublisher()
    }
}

extension VoteUseCase {

    private func filterSelectedResult(voteInfoList: [VoteInfoModel]) -> (agree: [VoteInfoModel], disagree: [VoteInfoModel]) {
        return (voteInfoList.filter { $0.isAgree }, voteInfoList.filter { !$0.isAgree })
    }

    private func getTopConsumerTypes(for votes: [VoteInfoModel]) -> [ConsumerType] {
        return Dictionary(grouping: votes, by: { $0.consumerType })
            .sorted { $0.value.count > $1.value.count }
            .prefix(2)
            .map { ConsumerType(rawValue: $0.key) }
            .compactMap { $0 }
    }

    private func calculateRatio(for count: Int?, totalCount: Int?) -> Double {
        guard let count = count, let totalCount = totalCount, totalCount > 0 else { return 0 }
        return (Double(count) / Double(totalCount)) * 100
    }

    private func mapVoteModelWithVoteRatio(from vote: VoteModel) -> VoteModel {
        let voteCnt = vote.voteCount ?? 0
        let agreeRatio = calculateRatio(for: vote.voteCounts?.agreeCount, totalCount: vote.voteCount)
        let disagreeRatio = calculateRatio(for: vote.voteCounts?.disagreeCount, totalCount: vote.voteCount)

        return VoteModel(
            post: vote,
            agreeRatio: voteCnt > 0 ? agreeRatio : nil,
            disagreeRatio: voteCnt > 0 ? disagreeRatio : nil
        )
    }

    private func mapVoteDetailModelWithResult(from vote: VoteDetailModel) -> VoteDetailModel {
        guard let voteInfoList = vote.post.voteInfoList else {
            return vote
        }

        let result = filterSelectedResult(voteInfoList: voteInfoList)
        let agreeTopConsumerTypes = getTopConsumerTypes(for: result.agree)
        let disagreeTopConsumerTypes = getTopConsumerTypes(for: result.disagree)

        let mappedPost = mapVoteModelWithVoteRatio(from: vote.post)

        return VoteDetailModel(
            post: mappedPost,
            commentCount: vote.commentCount,
            commentPreview: vote.commentPreview,
            commentPreviewImage: vote.commentPreviewImage,
            agreeTopConsumers: agreeTopConsumerTypes,
            disagreeTopConsumers: disagreeTopConsumerTypes
        )
    }

}

final class StubVoteUseCase: VoteUseCaseType {

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        Just([VoteModel.voteStub1, VoteModel.voteStub2])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        Just(VoteDetailModel.voteDetailStub)
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func vote(postId: Int, myChoice: Bool) -> AnyPublisher<(Double, Double), WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}
