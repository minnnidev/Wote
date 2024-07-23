//
//  VoteSearchResultCell.swift
//  TwoHoSun
//
//  Created by 김민 on 7/24/24.
//

import SwiftUI

struct VoteSearchResultCell: View {
    let vote: VoteModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                ProfileImageView(imageURL: vote.author.profileImage)
                    .frame(width: 32, height: 32)

                Text(vote.author.nickname)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.white)

                Spacer()

                ConsumerTypeLabel(
                    consumerType: ConsumerType(rawValue: vote.author.consumerType) ?? .adventurer,
                    usage: .cell
                )
            }

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if vote.postStatus == PostStatus.closed.rawValue {
                            EndLabel()
                        }

                        Text(vote.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }

                    Text(vote.contents ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(.bottom, 9)

                    HStack(spacing: 0) {
                        if let price = vote.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }

                        Text(vote.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray100)
                }

                Spacer()

                ZStack {
                    CardImageView(imageURL: vote.image)
                        .opacity(vote.postStatus == PostStatus.closed.rawValue
                                 ? 0.5 : 1.0)

                    if let voteResult = vote.voteResult {
                        VoteResultType(voteResult: voteResult).stampImage
                            .offset(x: -16, y: 16)
                    }

                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color.disableGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VoteSearchResultCell(
        vote: .voteStub2
    )
}
