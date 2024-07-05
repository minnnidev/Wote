//
//  DetailHeaderViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/24/23.
//

import Combine
import SwiftUI

final class DetailHeaderViewModel: ObservableObject {

    private var cancellable = Set<AnyCancellable>()

    func subscribeReview(postId: Int) {
        // TODO: 후기 구독
    }

    func deleteSubscribeReview(postId: Int) {
        // TODO: 후기 구독 취소
    }
}
