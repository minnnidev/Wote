//
//  ReviewDetailModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Foundation

struct ReviewDetailModel {
    let originalPost: ReviewModel
    let reviewPost: PostModel
    let isMine: Bool
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}

struct ReviewDetailResponseObject: Codable {
    let originalPost: ReviewResponseObject
    let reviewPost: PostResponseObject
    let isMine: Bool
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}
