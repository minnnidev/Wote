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
}

final class VoteDataSource: VoteDataSourceType {
    
    private let provider = MoyaProvider<VoteAPI>()

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
}
