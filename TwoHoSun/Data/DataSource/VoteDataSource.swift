//
//  VoteDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Combine
import Moya

protocol VoteDataSourceType {
    func getVotes(_ object: VoteRequestObject) -> AnyPublisher<[PostResponseObject], APIError>
    func getVoteDetail(_ postId: Int) -> AnyPublisher<VoteDetailResponseObject, APIError>
    func postVote(_ postId: Int, _ object: ChooseRequestObject) -> AnyPublisher<VoteCountsResponseObject, APIError>
    func registerVote(_ object: VoteCreateRequestObject) -> AnyPublisher<Void, APIError>
}

final class VoteDataSource: VoteDataSourceType {

    typealias Target = VoteAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func getVotes(_ object: VoteRequestObject) -> AnyPublisher<[PostResponseObject], APIError> {
        provider.requestPublisher(Target.getVotes(object), [PostResponseObject].self)
    }

    func getVoteDetail(_ postId: Int) -> AnyPublisher<VoteDetailResponseObject, APIError> {
        provider.requestPublisher(Target.getVoteDetail(postId), VoteDetailResponseObject.self)
    }

    func postVote(_ postId: Int, _ object: ChooseRequestObject) -> AnyPublisher<VoteCountsResponseObject, APIError> {
        provider.requestPublisher(Target.postVote(postId: postId, requestObject: object), VoteCountsResponseObject.self)
    }

    func registerVote(_ object: VoteCreateRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.registerVote(object))
    }
}
