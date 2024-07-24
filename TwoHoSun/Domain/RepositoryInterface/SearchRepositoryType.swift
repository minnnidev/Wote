//
//  SearchRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol SearchRepositoryType {
    func getVoteResults(scope: VisibilityScopeType, postStatus: PostStatus, page: Int, size: Int, keyword: String) -> AnyPublisher<[VoteModel], WoteError>
    func getReviewResults(scope: VisibilityScopeType, page: Int, size: Int, keyword: String) -> AnyPublisher<[ReviewModel], WoteError>
}
