//
//  VoteUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

protocol VoteUseCaseType {

}

final class VoteUseCase: VoteUseCaseType {

    private let repository: VoteRepositoryType

    init(repository: VoteRepositoryType) {
        self.repository = repository
    }
}

final class StubVoteUseCase: VoteUseCaseType {

}
