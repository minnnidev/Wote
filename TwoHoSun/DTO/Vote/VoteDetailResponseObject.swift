//
//  VoteDetailResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteDetailResponseObject: Codable {
    let post: PostResponseObject
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
}

extension VoteDetailResponseObject {

    func toModel() -> VoteDetailModel {
        .init(
            post: post.toModel(),
            commentCount: commentCount,
            commentPreview: commentPreview,
            commentPreviewImage: commentPreviewImage
        )
    }
}
