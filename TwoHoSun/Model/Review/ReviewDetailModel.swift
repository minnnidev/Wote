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
