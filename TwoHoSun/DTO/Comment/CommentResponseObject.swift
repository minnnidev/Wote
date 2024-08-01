//
//  CommentResponseObject.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

struct CommentResponseObject: Codable {
    let commentId: Int
    let createDate: String
    let modifiedDate: String
    let content: String
    let subComments: [CommentResponseObject]?
    let isMine: Bool
    let author: AuthorResponseObject?
}

extension CommentResponseObject {

    func toModel() -> CommentModel {
        .init(
            commentId: commentId,
            createDate: createDate,
            modifiedDate: modifiedDate,
            content: content,
            subComments: subComments?.map { $0.toModel() },
            isMine: isMine,
            author: author?.toModel()
        )
    }
}
