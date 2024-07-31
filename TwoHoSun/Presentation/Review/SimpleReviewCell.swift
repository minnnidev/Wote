//
//  SimpleReviewCell.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import SwiftUI

struct SimpleReviewCell: View {
    let data: SimpleReviewModel

    var body: some View {
        ZStack(alignment: .leading) {
            Color.disableGray

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    PurchaseLabel(isPurchased: data.isPurchased)

                    Text(data.title)
                        .lineLimit(1)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.white)
                }

                Text(data.content)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 20)

        }
        .frame(width: 268, height: 82)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SimpleReviewCell(data: SimpleReviewModel.stub1)
}
