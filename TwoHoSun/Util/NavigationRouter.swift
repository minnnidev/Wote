//
//  NavigationManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/15/23.
//

import SwiftUI

// MARK: - 이전 Navigation

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

enum VoteTabDestination {

}

enum ReviewTabDestination {

}

final class NavigationRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    func pop() {
        guard !path.isEmpty else { return }

        path.removeLast()
    }

    func popToRootView() {
        path = .init()
    }
}
