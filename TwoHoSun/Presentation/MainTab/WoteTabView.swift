//
//  WoteTabType.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI

struct WoteTabView: View {
    @EnvironmentObject var appDependency: AppDependency

    @State private var visibilityScope = VisibilityScopeType.global
    @State private var isVoteCategoryButtonDidTap = false
    @State private var tabScrollHandler = WoteTabHandler()
    @State private var selectedTab = WoteTabType.consider

    @StateObject private var router = NavigationRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            TabView(selection: $selectedTab) {
                ForEach(WoteTabType.allCases, id: \.self) { tab in
                    Group {
                        switch tab {
                        case .consider:
                            VoteListView(viewModel: appDependency.container.resolve(VoteListViewModel.self)!)
                                .environmentObject(router)
                        case .review:
                            ReviewListView(viewModel:appDependency.container.resolve(ReviewListViewModel.self)!)
                                .environmentObject(router)
                        case .myPage:
                            MyPageView()
                        }
                    }
                    .tabItem {
                        Image(selectedTab == tab ?
                              tab.selectedTabIcon : tab.unselectedTabIcon)
                        Text(tab.tabTitle)
                    }
                    .tag(tab)
                }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                UITabBar.appearance().backgroundColor = .background
                UITabBar.appearance().unselectedItemTintColor = .gray400
                UITabBar.appearance().standardAppearance = appearance
            }
            .navigationTitle(tabScrollHandler.selectedTab.tabTitle)
            .toolbar(.hidden, for: .navigationBar)
            .tint(Color.accentBlue)
            .navigationDestination(for: WoteDestination.self) { dest in
                switch dest {

                case .search:
                    SearchView(viewModel: appDependency.container.resolve(SearchViewModel.self)!)
                        .environmentObject(router)

                case let .voteDetail(postId):
                    DetailView(viewModel: appDependency.container.resolve(DetailViewModel.self, argument: postId)!)
                        .environmentObject(router)

                case let .reviewDetail(postId):
                    ReviewDetailView(
                        viewModel: appDependency.container.resolve(ReviewDetailViewModel.self, argument: postId)!
                    )
                    .environmentObject(router)
                }
            }
        }
    }
}

#Preview {
    WoteTabView()
        .environmentObject(AppDependency())
}
