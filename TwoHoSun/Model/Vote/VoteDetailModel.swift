//
//  VoteDetailModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteDetailModel {
    let post: VoteModel
    let commentCount: Int?
    let commentPreview: String?
    let commentPreviewImage: String?
    let agreeTopConsumers: [ConsumerType]?
    let disagreeTopConsumers: [ConsumerType]?

    init(
        post: VoteModel, 
        commentCount: Int?,
        commentPreview: String?,
        commentPreviewImage: String?,
        agreeTopConsumers: [ConsumerType]? = nil,
        disagreeTopConsumers: [ConsumerType]? = nil
    ) {
        self.post = post
        self.commentCount = commentCount
        self.commentPreview = commentPreview
        self.commentPreviewImage = commentPreviewImage
        self.agreeTopConsumers = agreeTopConsumers
        self.disagreeTopConsumers = disagreeTopConsumers
    }
}

extension VoteDetailModel {

    static var voteDetailStub: VoteDetailModel {
        .init(
            post: .voteStub1,
            commentCount: 10,
            commentPreview: "미리보기",
            commentPreviewImage: nil
        )
    }
}
