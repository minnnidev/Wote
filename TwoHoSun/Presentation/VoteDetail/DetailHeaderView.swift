//
//  DetailHeaderView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/16/23.
//

import SwiftUI

struct DetailHeaderView: View {
    @EnvironmentObject var router: NavigationRouter

    @State var alertOn = false

    var data: VoteDetailModel

    var body: some View {
        switch PostStatus(rawValue: data.post.postStatus) {

        case .active:
            activeVoteHeaderView(author: data.post.author, isMine: data.post.isMine)

        case .closed:
            if let isMine = data.post.isMine,
                let hasReview = data.post.hasReview {
                let closedPostState = ClosedPostStatus(isMine: isMine, hasReview: hasReview)!

                closedVoteHeaderView(author: data.post.author,
                                     closedState: closedPostState,
                                     post: data)
            } else {
                EmptyView()
            }

        default:
            EmptyView()
        }
    }

    private func activeVoteHeaderView(author: AuthorModel, isMine: Bool?) -> some View {
        HStack(spacing: 3) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 7)
            Text(author.nickname)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.whiteGray)

            if let isMine = isMine {
                if isMine {
                    Text("님의 소비 고민")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.whiteGray)
                    Spacer()
                } else {
                    Text("님의 구매후기 받기")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.whiteGray)

                    Spacer()

                    Toggle("", isOn: $alertOn)
                        .toggleStyle(AlertCustomToggle())
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 13)
    }

    private func closedVoteHeaderView(author: AuthorModel,
                                      closedState: ClosedPostStatus,
                                      post: VoteDetailModel) -> some View {
        HStack(spacing: 3) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 7)

            Text(author.nickname)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.whiteGray)

            Text(closedState.description)
                .font(.system(size: 13))
                .foregroundStyle(Color.whiteGray)

            Spacer()

            Button {
                destinationForHeaderButton(closedState, post: post)
            } label: {
                if closedState != ClosedPostStatus.othersPostWithoutReview {
                    headerButton(closedState.buttonView)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }

    private func headerButton(_ buttonView: some View) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 50, height: 42)
                .foregroundStyle(Color.gray200)
                .clipShape(.rect(cornerRadius: 6))

            buttonView
                .foregroundStyle(Color.lightBlue500)
        }
    }

    private func calculateVoteResult(_ voteCounts: VoteCountsModel) -> String {
        var voteResult = VoteResultType.buy

        if voteCounts.agreeCount == voteCounts.disagreeCount {
            voteResult = .draw
        } else if voteCounts.agreeCount > voteCounts.disagreeCount {
            voteResult = .buy
        } else {
            voteResult = .notBuy
        }

        return voteResult.rawValue
    }

    private func destinationForHeaderButton(_ closedPostState: ClosedPostStatus, post: VoteDetailModel) {
        switch closedPostState {

        case .myPostWithoutReview:
            // TODO: 후기 작성으로 이동
            return

        case .othersPostWithoutReview:
            // TODO: 후기 작성으로 이동
            return

        case .myPostWithReview, .othersPostWithReview:
            // TODO: 후기 뷰로 이동 (투표 id로 접근하는 로직)
            return
        }
    }
}

struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(width: 65, height: 25)
                .background(isOn ? Color.lightBlue : Color.darkblue)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .offset(x: isOn ? 6 : 28)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 45 : 6)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 65, height: 25)
                }
        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
    }
}
