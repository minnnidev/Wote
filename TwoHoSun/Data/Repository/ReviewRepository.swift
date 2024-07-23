//
//  ReviewRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

final class ReviewRepository: ReviewRepositoryType {

    private let reviewDataSource: ReviewDataSourceType

    init(reviewDataSource: ReviewDataSourceType) {
        self.reviewDataSource = reviewDataSource
    }
}
