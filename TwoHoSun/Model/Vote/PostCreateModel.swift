//
//  VoteCreateModel.swift
//  TwoHoSun
//
//  Created by 김민 on 7/17/24.
//

import Foundation

struct VoteCreateModel {
    let visibilityScope: VisibilityScopeType
    let title: String
    let price: Int?
    let contents: String?
    let externalURL: String?
    let image: Data?
}

extension VoteCreateModel {

    func toObject() -> VoteCreateRequestObject {
        .init(
            visibilityScope: visibilityScope,
            title: title,
            price: price,
            contents: contents,
            externalURL: externalURL,
            image: image
        )
    }
}
