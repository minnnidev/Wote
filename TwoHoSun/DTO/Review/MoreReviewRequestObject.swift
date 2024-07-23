//
//  MoreReviewRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct MoreReviewRequestObject: Codable {
    let visibilityScope: String
    let page: Int
    let size: Int
    let reviewType: String
}
