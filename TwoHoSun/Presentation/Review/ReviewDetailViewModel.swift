//
//  ReviewDetailViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Combine
import SwiftUI

final class ReviewDetailViewModel: ObservableObject {
    @Published var reviewData: ReviewDetailModel?
    @Published var postId = 0
    @Published var isMine = false
    @Published var reviewId = 0
    @Published var error: NetworkError?

    private var cancellable = Set<AnyCancellable>()
    private var reviewPostId = 0

    func fetchReviewDetail(reviewId: Int) {
        // TODO: 리뷰 디테일 조회
    }

    func fetchReviewDetail(postId: Int) {
        // TODO: 투표 디테일 조회
    }

    func deleteReview(postId: Int) {
        // TODO: 리뷰 삭제
    }
}
