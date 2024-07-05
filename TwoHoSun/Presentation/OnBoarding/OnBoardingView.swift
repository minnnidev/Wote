//
//  Onboarding.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI
import AuthenticationServices
import Combine

struct OnBoardingView : View {
    @State private var goProfileView = false
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("onboardingBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 26) {
                            Image("logo")
                            Text("청소년의 소비고민, 투표로 물어보기")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 120)
                    Spacer()
                    Image("onboardingIllust")
                    Spacer()
                    VStack(spacing: 12) {
                        Text("계속하려면 로그인 하세요")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.bottom, 4)
                        appleLoginButton
                        hyeprLinkText
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 26)
            }
            .sheet(isPresented: $viewModel.showSheet) {
                BottomSheetView(goProfileView: $goProfileView)
                    .presentationDetents([.medium])
            }
        }
    }
}

extension OnBoardingView {

    private var appleLoginButton: some View {
        NavigationLink {
            ProfileSettingsView(viewType: .setting)
        } label: {
            Text("Apple Login")
        }
    }

    private var hyeprLinkText: some View {
        HStack {
            Text("[이용 약관](https://hansn97.notion.site/Wote-dcd81699a906483d8b91f88f88164d31)")
            + Text(" 및 ")
            + Text("[개인정보 보호정책](https://hansn97.notion.site/88ed8c9e4dd04f31b071c6b43d32a828?pvs=4)")
            + Text(" 확인하기")
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.subGray1)
    }
}
