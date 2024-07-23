//
//  SimpleReviewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

struct SimpleReviewModel {
    let id: Int
    let isPurchased: Bool
    let title: String
    let content: String
}

extension SimpleReviewModel {

    static var stub1: SimpleReviewModel {
        .init(
            id: 1,
            isPurchased: false,
            title: "ACG 마운틴 플라이 살까 말까?",
            content: "어쩌고저쩌고 50자 미만!"
        )
    }
}
