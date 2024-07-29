//
//  MyPageVoteCell.swift
//  TwoHoSun
//
//  Created by 김민 on 7/29/24.
//

import SwiftUI

struct MyPageVoteCell: View {
    @EnvironmentObject var router: NavigationRouter

    let myVote: MyVoteModel

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                if myVote.postStatus == "CLOSED" { EndLabel() }

                                Text(myVote.title)
                                    .font(.system(size: 16, weight: .bold))
                            }

                            if let contents = myVote.contents {
                                Text(contents)
                                    .lineLimit(1)
                                    .font(.system(size: 14))
                                    .padding(.top, 6)
                            }
                        }

                        Spacer()
                    }
                    .foregroundStyle(Color.white)

                    HStack(spacing: 0) {
                        if let price = myVote.price {
                            Text("가격: \(price)원")
                            Text(" · ")
                        }
                        Text(myVote.createDate.convertToStringDate() ?? "")
                    }
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.priceGray)
                    .padding(.top, 15)
                }

                Spacer()

                ZStack {
                    CardImageView(imageURL: myVote.image)
                        .opacity(myVote.postStatus == PostStatus.closed.rawValue
                                 ? 0.5 : 1.0)

                    if let voteResult = myVote.voteResult {
                        VoteResultType(voteResult: voteResult).stampImage
                            .offset(x: -16, y: 16)
                    }
                }
            }

            if !(myVote.hasReview ?? true) && myVote.postStatus == "CLOSED" {
                Button {
                    router.push(to: WoteDestination.reviewWrite(postId: myVote.id))
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.lightBlue, lineWidth: 1.0)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)

                        Text("후기 작성하기")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 18)
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
    }
}

#Preview {
    MyPageVoteCell(myVote: .myVoteStub)
        .environmentObject(NavigationRouter())
}
