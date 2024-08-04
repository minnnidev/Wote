//
//  TypeTestResultView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestResultView: View {
    @EnvironmentObject var router: NavigationRouter

    var spendType: ConsumerType

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)

                HStack {
                    Text(spendType.description)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.lightBlue)
                        .kerning(-1)

                    Spacer()
                }
                .padding(.bottom, 24)

                HStack {
                    Text(spendType.title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)

                    Spacer()
                }

                Spacer()

                spendType.icon

                Spacer()

                pushToHomeButton
                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension TypeTestResultView {

    private var pushToHomeButton: some View {
        Button {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                router.pop(of: 3)
            }
        } label: {
            Text("확인")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.lightBlue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    TypeTestResultView(spendType: .riskAverse)
        .environmentObject(NavigationRouter())
}
