//
//  VoteRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

final class VoteRepository: VoteRepositoryType {
    
    private let dataSource: VoteDataSourceType

    init(dataSource: VoteDataSourceType) {
        self.dataSource = dataSource
    }
}
