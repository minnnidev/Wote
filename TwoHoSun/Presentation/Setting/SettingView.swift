//
//  SettingView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

struct SettingView: View {
    @State private var isSubmited: Bool = false
    @State private var showLogOut: Bool = false

    @StateObject var viewModel: SettingViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            List {
                settingSectionView {
                    settingLinkView(.notification) {
                        SettingNotificationView()
                    }
                    settingLinkView(.block) {
                        SettingBlockView(viewModel: viewModel)
                    }
                }
                
                settingSectionView {
                    settingLinkView(.announcement) {
                        SettingAnnouncementView()
                    }
                    settingLinkView(.questions) {
                        SettingQuestionsView(isSubmited: $isSubmited, viewModel: SettingQuestionsViewModel())
                    }
                    settingLinkView(.terms) {
                        SettingTermsView(viewModel: viewModel)
                    }
                    appVersionView
                }
                settingSectionView {
                    logOutView
                }
            }
            .foregroundStyle(.white)
            .scrollContentBackground(.hidden)

            if showLogOut {
                CustomAlertModalView(alertType: .logOut, isPresented: $showLogOut) {
                   // TODO: 로그아웃
                }
            }

            if isSubmited {
                ZStack {
                    Color.black.opacity(0.7)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightBlue)
                        .frame(width: 283, height: 36)

                    Text("금방 답변 드리겠습니다 :)")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isSubmited = false
                    }
                }
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension SettingView {

    private var appVersionView: some View {
        HStack(spacing: 16) {
            ZStack {
                SettingType.appVersion.color
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 28, height: 28)

                Image(systemName: SettingType.appVersion.icon)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
            }
            Text(SettingType.appVersion.label)
            Spacer()
            Text(version ?? "")
                .foregroundStyle(Color.subGray1)
                .font(.system(size: 14))
        }
    }
    
    private var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String
             else { return nil }
        
        return "v \(version)"
    }
    
    private var logOutView: some View {
        Button {
            withAnimation {
                showLogOut = true
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    SettingType.logOut.color
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 28, height: 28)

                    Image(systemName: SettingType.logOut.icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                }
                Text(SettingType.logOut.label)
            }
        }
    }
    
    private func settingSectionView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        Section {
            content()
        }
        .listRowBackground(Color.disableGray)
        .listRowSeparatorTint(Color.gray600)
    }
    
    private func settingLinkView<Content: View>(_ type: SettingType, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink {
            content()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    type.color
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 28, height: 28)

                    Image(systemName: type.icon)
                        .font(.system(size: 15))
                }

                Text(type.label)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack {
        SettingView(viewModel: .init(
            userUseCase: StubUserUseCase(),
            authUseCase: StubAuthUseCase()
        )
        )
    }
}
