//
//  WoteTabType.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI

struct WoteTabView: View {
    @State private var visibilityScope = VisibilityScopeType.global
    @State private var isVoteCategoryButtonDidTap = false
    @State private var tabScrollHandler = WoteTabHandler()
    @State private var selectedTab = WoteTabType.consider

    @EnvironmentObject private var navigationRouter: NavigationManager

    var body: some View {
        NavigationStack(path: $navigationRouter.navigatePath) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    navigationBar
                    TabView(selection: $selectedTab) {
                        ForEach(WoteTabType.allCases, id: \.self) { tab in
                            Group {
                                switch tab {
                                case .consider:
                                    ConsiderationView(visibilityScope: $visibilityScope, scrollToTop: $tabScrollHandler.scrollToTop)
                                case .review:
                                    ReviewView(visibilityScope: $visibilityScope)
                                case .myPage:
                                    MyPageView(selectedVisibilityScope: $visibilityScope)
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
                }

                if isVoteCategoryButtonDidTap {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isVoteCategoryButtonDidTap = false
                        }
                    HStack(spacing: 0) {
                        voteCategoryButton
                        Spacer()
                        notificationButton
                            .hidden()
                        searchButton
                            .hidden()
                    }
                    .padding(.horizontal, 16)
                    voteCategoryMenu
                        .offset(x: 16, y: 40)
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
            .navigationDestination(for: AllNavigation.self) { destination in
                switch destination {
                case .makeVoteView:
                    VoteWriteView()
                case let .detailView(postId: postId, dirrectComments: dirrectComments, isShowingItems: isShowingItems):
                    DetailView(postId: postId)
                case let .reviewDetailView(postId: postId?,
                                           reviewId: reviewId?,
                                           directComments: directComments,
                                           isShowingItems: isShowingItems):
                    ReviewDetailView()
                case .reviewWriteView:
                    ReviewWriteView()
                default:
                    Text("default")
                }
            }
        }
    }
}

extension WoteTabView {

    @ViewBuilder
    private var navigationBar: some View {
        switch tabScrollHandler.selectedTab {
        case .consider, .review:
            HStack(spacing: 0) {
                voteCategoryButton
                Spacer()
                notificationButton
                    .padding(.trailing, 8)
                searchButton
            }
            .padding(.top, 2)
            .padding(.bottom, 9)
            .padding(.horizontal, 16)
            .background(Color.background)
        case .myPage:
            HStack {
                Image("imgWoteLogo")
                Spacer()
                settingButton
            }
            .padding(.top, 2)
            .padding(.bottom, 9)
            .padding(.horizontal, 16)
            .background(Color.background)
        }
    }

    private var notificationButton: some View {
        Button {

        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var searchButton: some View {
        Button {

        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var settingButton: some View {
        Button {

        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 39, height: 39)
                    .foregroundStyle(Color.disableGray)
                Image(systemName: "gear")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.woteWhite)
            }
        }
    }

    private var voteCategoryMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                visibilityScope = .global
                isVoteCategoryButtonDidTap = false
            } label: {
                Text("전국 투표")
                    .padding(.leading, 15)
                    .padding(.top, 14)
                    .padding(.bottom, 12)
            }
            .contentShape(.rect)
            Divider()
                .background(Color.gray300)
            Button {
                visibilityScope = .school
                isVoteCategoryButtonDidTap = false
            } label: {
                Text("우리 학교 투표")
                    .padding(.leading, 15)
                    .padding(.top, 12)
                    .padding(.bottom, 14)
            }
            .contentShape(.rect)
        }
        .frame(width: 131, height: 88)
        .font(.system(size: 14))
        .foregroundStyle(Color.woteWhite)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.disableGray)
        )
    }

    private var voteCategoryButton: some View {
        ZStack(alignment: .topLeading) {
            Button {
                isVoteCategoryButtonDidTap.toggle()
            } label: {
                HStack(spacing: 5) {
                    Text(visibilityScope.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.subGray1)
                }
            }
        }
    }
}
