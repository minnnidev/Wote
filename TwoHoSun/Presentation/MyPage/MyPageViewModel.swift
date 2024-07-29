//
//  MyPageViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import Combine
import SwiftUI

final class MyPageViewModel: ObservableObject {
    
    var selectedMyPageListType = MyPageListType.myVote

    var profile: ProfileModel?
    var total = 0

    private var cacellabels: Set<AnyCancellable> = []

    private let myPageUseCase: MyPageUseCaseType

    init(myPageUseCase: MyPageUseCaseType) {
        self.myPageUseCase = myPageUseCase
    }

    func requestPosts(postType: PostService) {

    }

    func fetchPosts(isFirstFetch: Bool = true) {

    }

    func fetchMorePosts() {

    }
}
