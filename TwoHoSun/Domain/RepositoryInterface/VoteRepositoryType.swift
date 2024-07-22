//
//  VoteRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation
import Combine

protocol VoteRepositoryType {
    func getVotes(page: Int, size: Int, scope: VisibilityScopeType) -> AnyPublisher<[VoteModel], WoteError>
    func getVoteDetail(postId: Int) -> AnyPublisher<VoteDetailModel, WoteError>
    func vote(postId: Int, myChoice: Bool) -> AnyPublisher<VoteCountsModel, WoteError> 
    func createVote(_ createdVote: VoteCreateModel) -> AnyPublisher<Void, WoteError>
    func deleteVote(postId: Int) -> AnyPublisher<Void, WoteError>
    func closeVote(postId: Int) -> AnyPublisher<Void, WoteError>
}
