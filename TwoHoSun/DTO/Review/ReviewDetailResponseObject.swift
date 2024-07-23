//
//  ReviewDetailResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct ReviewDetailResponseObject: Codable {
    let originalPost: PostResponseObject
    let reviewPost: ReviewResponseObject
    let isMine: Bool
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}

extension ReviewDetailResponseObject {

    func toModel() -> ReviewDetailModel {
        .init(
            originalPost: originalPost.toModel(),
            reviewPost: reviewPost.toModel(),
            isMine: isMine,
            commentCount: commentCount,
            commentPreview: commentPreview,
            commentPreviewImage: commentPreviewImage
        )
    }
}
