//
//  ReviewCreateRequestObject.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import Foundation

struct ReviewCreateRequestObject: Codable {
    let title: String
    let contents: String?
    let price: Int?
    let isPurchased: Bool
    let image: Data?
}
