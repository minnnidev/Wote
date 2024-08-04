//
//  WoteNavigationBar.swift
//  TwoHoSun
//
//  Created by 김민 on 7/16/24.
//

import SwiftUI

struct WoteNavigationBar: View {
    @EnvironmentObject var router: NavigationRouter

    @Binding var selectedTab: WoteTabType
    @Binding var visibilityScope: VisibilityScopeType

    var body: some View {
        switch selectedTab {
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
}

extension WoteNavigationBar {

    private var notificationButton: some View {
        Button {
            router.push(to: WoteDestination.notification)
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
            router.push(to: WoteDestination.search)
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
            router.push(to: WoteDestination.setting)
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

#Preview {
    WoteNavigationBar(
        selectedTab: .constant(.consider),
        visibilityScope: .constant(.global)
    )
    .environmentObject(NavigationRouter())
}

