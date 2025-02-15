//
//  NoReviewView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

struct NoReviewView: View {
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Image("imgNoReview")
                .padding(.bottom, 32)
            Text("아직 소비후기가 없어요.\n고민을 나눈 후 소비후기를 들려주세요.")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.subGray1)
                .multilineTextAlignment(.center) 
            Button {
                // TODO: - 테스트하지 않았다면 테스트로, 했다면 투표 등록으로 이동
            } label: {
                Text("고민 등록하러 가기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.lightBlue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.lightBlue, lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    NoReviewView()
}
