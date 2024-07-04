//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Combine
import SwiftUI

final class MyPageViewModel: ObservableObject {
    var selectedMyPageListType = MyPageListType.myVote
    var selectedMyVoteCategoryType = MyVoteCategoryType.all
    var selectedMyReviewCategoryType = MyReviewCategoryType.all

    var profile: ProfileModel?
    var cacellabels: Set<AnyCancellable> = []
    var total = 0

    private var votePage = 0
    private var reviewPage = 0
    private var isVoteLastPage = false
    private var isReviewLastPage = false

    func requestPosts(postType: PostService) {

    }

    func fetchPosts(isFirstFetch: Bool = true) {
        switch selectedMyPageListType {
        case .myVote:
            requestPosts(postType: .getMyPosts(page: votePage,
                                               size: 10,
                                               myVoteCategoryType: selectedMyVoteCategoryType.parameter))
        case .myReview:
            requestPosts(postType: .getMyReviews(page: reviewPage,
                                                 size: 10,
                                                 myReviewCategoryType: selectedMyReviewCategoryType.parameter))
        }
    }

    func fetchMorePosts() {
        switch selectedMyPageListType {
        case .myVote:
            guard !isVoteLastPage else { return }
            votePage += 1
        case .myReview:
            guard !isReviewLastPage else { return }
            reviewPage += 1
        }
        fetchPosts(isFirstFetch: false)
    }
}
