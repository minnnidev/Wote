//
//  RegisterCommentRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 8/1/24.
//

import Foundation

struct RegisterCommentRequestObject: Codable {
    let postId: Int
    let contents: String
}
