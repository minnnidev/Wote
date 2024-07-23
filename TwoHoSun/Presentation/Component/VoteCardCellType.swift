//
//  VoteCardCellType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import SwiftUI

enum VoteResultType: String {
    case buy = "BUY"
    case draw = "NOT_BUY"
    case notBuy = "DRAW"

    init(voteResult: String) {
        switch voteResult {
        case "BUY":
            self = .buy
        case "NOT_BUY":
            self = .notBuy
        case "DRAW":
            self = .draw
        default:
            self = .buy
        }
    }

    var stampImage: Image {
        switch self {
        case .buy:
            Image("imgBuy")
        case .draw:
            Image("imgDraw")
        case .notBuy:
            Image("imgNotBuy")
        }
    }
}
