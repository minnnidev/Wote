//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

// MARK: - 이전 Navigation

enum ProfileSettingType: Decodable {
    case setting, modfiy
}

enum AllNavigation: Decodable, Hashable {
    case considerationView
    case writeReiview
    case detailView(postId: Int,
                    dirrectComments: Bool = false,
                    isShowingItems: Bool = true)
    case reviewView
    case makeVoteView
    case testIntroView
    case testView
    case settingView
    case mypageView
    case searchView
    case notiView
    case reviewDetailView(postId: Int?, 
                          reviewId: Int?,
                          directComments: Bool = false,
                          isShowingItems: Bool = true)
    case reviewWriteView
    case profileSettingView(type: ProfileSettingType)
}

// MARK: - 리팩토링 중인 NavigationStack

enum WoteDestination: Hashable {
    case search
    case voteDetail(postId: Int)
    case reviewDetail(postId: Int)
}

enum VoteDestination: Hashable {
    case voteWrite
}

final class NavigationRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    func push<T: Hashable>(to view: T) {
        path.append(view)
    }

    func pop() {
        guard !path.isEmpty else { return }

        path.removeLast()
    }

    func popToRootView() {
        path = .init()
    }

    func setRoot<T: Hashable>(to view: T) {
        path = .init()
        path.append(view)
    }
}
