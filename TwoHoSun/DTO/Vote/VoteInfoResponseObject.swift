//
//  VoteInfoResponseObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import Foundation

struct VoteInfoResponseObject: Codable {
    let isAgree: Bool
    let consumerType: String
}

extension VoteInfoResponseObject {

    func toModel() -> VoteInfoModel {
        .init(isAgree: isAgree, consumerType: consumerType)
    }
}
