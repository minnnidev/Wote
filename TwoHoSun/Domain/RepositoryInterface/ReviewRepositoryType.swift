//
//  ReviewRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation
import Combine

protocol ReviewRepositoryType {
    func getReviews(visibilityScope: VisibilityScopeType) -> AnyPublisher<ReviewTabModel, WoteError>
    func getMoreReviews(visibilityScope: VisibilityScopeType, page: Int, size: Int, reviewType: ReviewType) -> AnyPublisher<[ReviewModel], WoteError>
    func getReviewDetail(reviewId: Int) -> AnyPublisher<ReviewDetailModel, WoteError>
    func createReview(postId: Int, review: ReviewCreateModel) -> AnyPublisher<Void, WoteError>
    func deleteReview(postId: Int) -> AnyPublisher<Void, WoteError>
}
