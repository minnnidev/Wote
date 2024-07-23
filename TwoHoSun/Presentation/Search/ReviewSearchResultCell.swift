//
//  ReviewResultCell.swift
//  TwoHoSun
//
//  Created by 김민 on 7/24/24.
//

import SwiftUI

struct ReviewSearchResultCell: View {
    let review: ReviewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                ProfileImageView(imageURL: review.author?.profileImage)
                    .frame(width: 32, height: 32)

                Text(review.author?.nickname ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.white)

                Spacer()

                ConsumerTypeLabel(
                    consumerType: ConsumerType(
                        rawValue: review.author?.consumerType ?? ConsumerType.adventurer.rawValue
                    ) ?? .adventurer,
                    usage: .cell
                )
            }

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        
                        PurchaseLabel(isPurchased: review.isPurchased ?? false)

                        Text(review.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }

                    Text(review.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)

                    HStack(spacing: 0) {
                        if let price = review.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }

                        Text(review.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }

                Spacer()

                CardImageView(imageURL: review.image)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.disableGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ReviewSearchResultCell(
        review: .reviewStub1
    )
}
