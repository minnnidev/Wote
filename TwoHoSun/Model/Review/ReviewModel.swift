//
//  SummaryPostModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct ReviewModel: Identifiable {
    var id: Int
    var createDate: String
    var modifiedDate: String
    var author: AuthorModel?
    var postStatus: String
    var title: String
    var image: String?
    var contents: String?
    var price: Int?
    var isPurchased: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case createDate, modifiedDate, author, postStatus, title, image, contents,
             price, isPurchased
    }
}

extension ReviewModel {

    static var summaryStub1: ReviewModel {
        .init(
            id: 1,
            createDate: "",
            modifiedDate: "",
            author: .authorStub1,
            postStatus: "REVIEW",
            title: "제목",
            image: nil,
            contents: "내용업듬",
            price: 3000,
            isPurchased: true)
    }
}
