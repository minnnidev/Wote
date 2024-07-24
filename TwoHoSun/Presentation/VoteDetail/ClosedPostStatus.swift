//
//  ClosedPostStatus.swift
//  TwoHoSun
//
//  Created by 김민 on 7/25/24.
//

import SwiftUI

enum ClosedPostStatus: Codable {
    case myPostWithReview
    case myPostWithoutReview
    case othersPostWithReview
    case othersPostWithoutReview

    init?(isMine: Bool?, hasReview: Bool?) {
        switch (isMine, hasReview) {
        case (true, true):
            self = .myPostWithReview
        case (true, false):
            self = .myPostWithoutReview
        case (false, true):
            self = .othersPostWithReview
        case (false, false):
            self = .othersPostWithoutReview
        case (_, _):
            return nil
        }
    }

    var description: String {
        switch self {
        case .myPostWithReview:
            return "님의 소비 후기"
        case .myPostWithoutReview:
            return "님! 상품에 대한 후기를 들려주세요!"
        case .othersPostWithReview:
            return "님의 소비후기 보러가기"
        case .othersPostWithoutReview:
            return "님이 아직 소비후기를 작성하기 전이에요!"
        }
    }

    @ViewBuilder
    var buttonView: some View {
        switch self {
        case .myPostWithoutReview:
            Image(systemName: "pencil.line")
                .font(.system(size: 20))
        case .othersPostWithoutReview:
            EmptyView()
        default:
            Image("icnReview")
        }
    }
}
