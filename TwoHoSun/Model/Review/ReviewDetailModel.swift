//
//  ReviewDetailModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/20/23.
//

import Foundation

struct ReviewDetailModel {
    let originalPost: VoteModel
    let reviewPost: ReviewModel
    let isMine: Bool
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}

extension ReviewDetailModel {

    static var reviewStub1: ReviewDetailModel {
        .init(
            originalPost: .voteStub1,
            reviewPost: .summaryStub1,
            isMine: false,
            commentCount: 3,
            commentPreview: nil,
            commentPreviewImage: nil
        )
    }
}
