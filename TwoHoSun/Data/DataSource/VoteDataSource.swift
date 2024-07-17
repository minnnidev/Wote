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
    
    private let provider = MoyaProvider<VoteAPI>(session: Session(interceptor: AuthInterceptor()))

    func getVotes(_ object: VoteRequestObject) -> AnyPublisher<[PostResponseObject], APIError> {
        provider.requestPublisher(.getVotes(object))
            .tryMap {
                try JSONDecoder().decode(GeneralResponse<[PostResponseObject]>.self, from: $0.data)
            }
            .compactMap { $0.data }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func getVoteDetail(_ postId: Int) -> AnyPublisher<VoteDetailResponseObject, APIError> {
        provider.requestPublisher(.getVoteDetail(postId))
            .tryMap {
                try JSONDecoder().decode(GeneralResponse<VoteDetailResponseObject>.self, from: $0.data)
            }
            .compactMap { $0.data }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func postVote(_ postId: Int, _ object: ChooseRequestObject) -> AnyPublisher<VoteCountsResponseObject, APIError> {
        provider.requestPublisher(.postVote(postId: postId, requestObject: object))
            .tryMap {
                try JSONDecoder().decode(GeneralResponse<VoteCountsResponseObject>.self, from: $0.data)
            }
            .compactMap { $0.data }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }

    func registerVote(_ object: VoteCreateRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestPublisher(.registerVote(object))
            .tryMap {
                try JSONDecoder().decode(GeneralResponse<NoData>.self, from: $0.data)
            }
            .map { _ in }
            .mapError { APIError.error($0) }
            .eraseToAnyPublisher()
    }
}
