//
//  ReviewTabModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/19/23.
//

import Foundation

struct ReviewTabResponseObject: Codable {
    let myConsumerType: String?
    var recentReviews: [SummaryPostResponseObject]?
    var allReviews: [SummaryPostResponseObject]
    var purchasedReviews: [SummaryPostResponseObject]
    var notPurchasedReviews: [SummaryPostResponseObject]
}

enum ReviewType: String, CaseIterable {
    case all = "ALL"
    case purchased = "PURCHASED"
    case notPurchased = "NOT_PURCHASED"

    var title: String {
        switch self {
        case .all:
            return "모두"
        case .purchased:
            return "샀다"
        case .notPurchased:
            return "안샀다"
        }
    }
}
