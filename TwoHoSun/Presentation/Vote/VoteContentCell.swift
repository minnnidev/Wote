//
//  VoteContentCell.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import SwiftUI

import Kingfisher

struct VoteContentCell: View {
    @State private var isButtonTapped = false
    @State private var isAlertShown = false

    var vote: VoteModel

    var voteTapped: (Bool) -> ()
    var detailTapped: () -> ()

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ProfileImageView(imageURL: vote.author.profileImage)
                    .frame(width: 32, height: 32)
                Text(vote.author.nickname)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                ConsumerTypeLabel(consumerType: ConsumerType(rawValue: vote.author.consumerType) ?? .adventurer,
                                  usage: .standard)
            }
            .padding(.bottom, 10)

            HStack(spacing: 4) {
                if vote.postStatus == PostStatus.closed.rawValue {
                    EndLabel()
                }

                Text(vote.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            Text(vote.contents ?? "")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.bottom, 8)

            HStack(spacing: 0) {
                if let price = vote.price {
                    Text("가격: \(price)원")
                    Text(" · ")
                }
                Text(vote.createDate.convertToStringDate() ?? "")
            }

            .font(.system(size: 14))
            .foregroundStyle(Color.gray100)
            .padding(.bottom, 10)

            HStack {
                InfoButton(label: "\(vote.voteCount ?? 0)명 투표", icon: "person.2.fill")
                Spacer()
                voteInfoButton(label: "댓글 \(vote.commentCount ?? 0)개", icon: "message.fill")
            }

            .padding(.bottom, 2)
            if let imageURL = vote.image {
                ImageView(imageURL: imageURL)
            } else {
                Image("imgDummyVote\(vote.id % 3 + 1)")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 16))
            }
            VStack(spacing: 10) {
                VStack {
                    if vote.postStatus == "CLOSED" || vote.myChoice != nil {
                        VoteResultView(myChoice: vote.myChoice,
                                       agreeRatio: vote.agreeRatio ?? 0,
                                       disagreeRatio: vote.disagreeRatio ?? 0)

                    } else {
                        IncompletedVoteButton(choice: .agree) {
                            voteTapped(true)
                        }
                        IncompletedVoteButton(choice: .disagree) {
                            voteTapped(false)
                        }
                    }
                }
                detailResultButton
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 24)
        .alert(isPresented: $isAlertShown) {
            Alert(title: Text("투표는 1번만 가능합니다."))
        }
    }
}

extension VoteContentCell {

    private func voteInfoButton(label: String, icon: String) -> some View {
        Button {
            detailTapped()
        } label: {
            HStack(spacing: 2) {
                Image(systemName: icon)
                Text(label)
            }
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(Color.darkGray2, in: .rect(cornerRadius: 34))
        }
    }

    private var detailResultButton: some View {
        Button {
            detailTapped()
        } label: {
                Text("상세보기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue100, in: Capsule())
        }
    }
}
