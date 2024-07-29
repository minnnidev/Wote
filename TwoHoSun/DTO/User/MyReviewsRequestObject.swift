//
//  MyReviewRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct MyReviewsRequestObject: Codable {
    let visibilityScope: String
    let page: Int
    let size: Int
}
