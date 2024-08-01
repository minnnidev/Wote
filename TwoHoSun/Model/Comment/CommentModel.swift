//
//  CommentModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation

struct CommentModel {
    let commentId: Int
    let createDate: String
    let modifiedDate: String
    let content: String
    let subComments: [CommentModel]?
    let isMine: Bool
    let author: AuthorModel?
}

extension CommentModel {

    static var commentStub1: CommentModel {
        .init(
            commentId: 1,
            createDate: "2024-07-25T01:58:07.347461",
            modifiedDate: "2024-07-25T01:58:07.347461",
            content: "댓글댓글댓글댓글댓글댓글댓글댓글",
            subComments: [.commentStub2, .commentStub3],
            isMine: true,
            author: .authorStub1
        )
    }

    static var commentStub2: CommentModel {
        .init(
            commentId: 2,
            createDate: "2024-07-25T01:58:07.347461",
            modifiedDate: "2024-07-25T01:58:07.347461",
            content: "답글",
            subComments: nil,
            isMine: true,
            author: .authorStub1
        )
    }

    static var commentStub3: CommentModel {
        .init(
            commentId: 4,
            createDate: "2024-07-25T01:58:07.347461",
            modifiedDate: "2024-07-25T01:58:07.347461",
            content: "답글",
            subComments: nil,
            isMine: false,
            author: .authorStub1
        )
    }
}
