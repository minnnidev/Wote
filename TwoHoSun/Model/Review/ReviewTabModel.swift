//
//  ReviewTabModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct ReviewTabModel {
    var recentReviews: [SimpleReviewModel]?
    var allReviews: [SummaryPostModel]
    var purchasedReviews: [SummaryPostModel]
    var notPurchasedReviews: [SummaryPostModel]
}

extension ReviewTabModel {

    static var reviewTabStub1: ReviewTabModel {
        .init(
            recentReviews: [.stub1],
            allReviews: [.summaryStub1],
            purchasedReviews: [.summaryStub1],
            notPurchasedReviews: [.summaryStub1]
        )
    }
}
