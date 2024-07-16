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
}
