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
}

final class VoteUseCase: VoteUseCaseType {

    private let voteRepository: VoteRepositoryType

    init(voteRepository: VoteRepositoryType) {
        self.voteRepository = voteRepository
    }

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        voteRepository.getVotes(page: page, size: size, scope: scope)
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        voteRepository.getVoteDetail(postId: postId)
            .map { [weak self] (vote: VoteDetailModel) -> VoteDetailModel in
                if let voteInfoList = vote.post.voteInfoList {
                    let result = self?.filterSelectedResult(voteInfoList: voteInfoList)
                    let agreeTopConsumerTypes = self?.getTopConsumerTypes(for: result?.agree ?? [])
                    let disagreeTopConsumerTypes = self?.getTopConsumerTypes(for: result?.disagree ?? [])

                    return .init(
                        post: vote.post,
                        commentCount: vote.commentCount,
                        commentPreview: vote.commentPreview,
                        commentPreviewImage: vote.commentPreviewImage,
                        agreeTopConsumers: agreeTopConsumerTypes,
                        disagreeTopConsumers: disagreeTopConsumerTypes
                    )
                } else {
                    return .init(
                        post: vote.post,
                        commentCount: vote.commentCount,
                        commentPreview: vote.commentPreview,
                        commentPreviewImage: vote.commentPreviewImage
                        )
                }
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
}

final class StubVoteUseCase: VoteUseCaseType {

    func loadVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError> {
        Just([VoteModel.voteStub1, VoteModel.voteStub2])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func loadVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}
