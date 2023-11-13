//
//  SettingTermsView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

enum TermsType {
    case first
    case second
    case third
    
    var label: String {
        switch self {
        case .first:
            "Wote 서비스 이용약관 동의"
        case .second:
            "개인정보 수집 및 이용 동의"
        case .third:
            "마케팅 정보 수신 동의"
        }
    }
    
    var icon: String {
        switch self {
        case .first:
            "1.square"
        case .second:
            "2.square"
        case .third:
            "3.square"
        }
    }
    
    var color: Color {
        switch self {
        case .first:
            Color.settingGray
        case .second:
            Color.settingGray
        case .third:
            Color.settingGray
        }
    }
}

struct SettingTermsView: View {
    @State private var isFirstOpened: Bool = false
    @State private var isSecondOpened: Bool = false
    @State private var isThirdOpened: Bool = false
    @State private var isWithdrawal: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                Section {
                    termsLinkView(.first) {
                        isFirstOpened.toggle()
                    }
                    termsLinkView(.second) {
                        isSecondOpened.toggle()
                    }
                    termsLinkView(.third) {
                        isThirdOpened.toggle()
                    }
                } header: {
                    Text("서비스 약관 내용")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.gray700)
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.disableGray)
                .listRowSeparatorTint(Color.gray600)
                Section {
                    withdrawalView
                } header: {
                    Text("로그인 정보")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.gray700)
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.disableGray)
                .listRowSeparatorTint(Color.gray600)
            }
            .scrollContentBackground(.hidden)
            if isWithdrawal {
                CustomAlertModalView(alertType: .withdrawal, isPresented: $isWithdrawal) {
                    isWithdrawal = false
                    print("탈퇴 완료!")
                }
            }
        }
        .fullScreenCover(isPresented: $isFirstOpened, content: {
            LinkView(externalURL: "https://hansn97.notion.site/Wote-dcd81699a906483d8b91f88f88164d31")
        })
        .fullScreenCover(isPresented: $isSecondOpened, content: {
            LinkView(externalURL: "https://hansn97.notion.site/88ed8c9e4dd04f31b071c6b43d32a828?pvs=4")
        })
        .fullScreenCover(isPresented: $isThirdOpened, content: {
            LinkView(externalURL: "https://hansn97.notion.site/3a21b194a622480b88e60a066f71c44f")
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("이용약관")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension SettingTermsView {
    private var withdrawalView: some View {
        Button {
            withAnimation {
                isWithdrawal = true
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Color.settingGray
                        .frame(width: 28, height: 28)
                        .clipShape(.rect(cornerRadius: 5))
                    Image(systemName:"xmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                }
                Text("회원 탈퇴")
            }
        }
    }
    
    private func termsLinkView(_ type: TermsType, content: @escaping () -> Void) -> some View {
        Button {
            content()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    type.color
                        .frame(width: 28, height: 28)
                        .clipShape(.rect(cornerRadius: 5))
                    Image(systemName: type.icon)
                        .font(.system(size: 15))
                }
                Text(type.label)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.subGray1)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack {
        SettingTermsView()
    }
}
