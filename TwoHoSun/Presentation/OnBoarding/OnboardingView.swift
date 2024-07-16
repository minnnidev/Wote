//
//  OnboardingView.swift
//  TwoHoSun
//
//  Created by 김민 on 7/9/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appDependency: AppDependency

    @AppStorage(AppStorageKey.loginState) private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn {
                WoteTabView()
            } else {
                LoginView(viewModel: appDependency.container.resolve(LoginViewModel.self)!)
            }
        }
        .onAppear {
            isLoggedIn = true
            KeychainManager.shared.save(key: TokenType.accessToken, token: "eyJwcm92aWRlcklkIjoiMDAxOTA0LjExZmQ0Zjc3ZGY3ZjQzNjBhNGIxOGMxZTgxMTYxMTA3LjA2MDgiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwcm92aWRlcklkIiwidHlwZSI6ImFjY2VzcyIsImlhdCI6MTcyMTAyNjQyNiwiZXhwIjoxNzIxNjMxMjI2fQ.Ofyyf622dP7SBzi_6BENGqcmvH1XVNuUyzF0Bq9XEgY")
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppDependency())
}
