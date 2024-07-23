//
//  ReviewUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

protocol ReviewUseCaseType {

}

final class ReviewUseCase: ReviewUseCaseType {
    
    private let reviewRepository: ReviewRepositoryType

    init(reviewRepository: ReviewRepositoryType) {
        self.reviewRepository = reviewRepository
    }
}

final class StubReviewUseCase: ReviewUseCaseType {
    
}
