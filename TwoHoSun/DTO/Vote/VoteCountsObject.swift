//
//  VoteCountsResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteCountsResponseObject: Codable {
    let agreeCount: Int
    let disagreeCount: Int
}

extension VoteCountsResponseObject {

    func toModel() -> VoteCountsModel {
        .init(agreeCount: agreeCount, disagreeCount: disagreeCount)
    }
}
