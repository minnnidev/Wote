//
//  CommentCell.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct CommentCell: View {

    enum UserCommentType {
        case normal, banned, deletedUser
    }

    @State private var isOpenComment: Bool = false
    @State private var isExpended: Bool = false
    @State private var canExpended: Bool?

    var replyButtonDidTapped: () -> Void
    var sheetButtonDidTapped: (Bool) -> Void

    let comment: CommentModel
//    var onReplyButtonTapped: () -> Void

//    init(comment: CommentsModel, onReplyButtonTapped: @escaping () -> Void, onConfirmDiaog: @escaping (Bool, Int) -> Void) {
//        self.comment = comment
//        self.onReplyButtonTapped = onReplyButtonTapped
//        self.onConfirmDiaog = onConfirmDiaog
//        if let subComments = comment.subComments {
//            self.childComments = subComments
//        }
//    }

    var body: some View {
        VStack(alignment: .leading) {
            makeCellView(comment: comment, parent: true)

            if let childComments = comment.subComments {
                if isOpenComment {
                    VStack {
                        ForEach(Array(childComments.enumerated()), id:  \.1.commentId) { index, comment in
                            let last = index == childComments.count - 1
                            makeCellView(comment: comment, parent: false)
                                .padding(.bottom, last ? 0 : 12)
                            if last {
                                moreToggleButton()
                            }
                        }
                    }
                    .padding(.leading, 26)
                    .padding(.top, 22)
                } else {
                    moreToggleButton()
                }
            }
        }
    }
}

extension CommentCell {

    private func lastEditTimeText(comment: CommentModel) -> some View {
        var isEdited: String {
            return comment.modifiedDate != comment.createDate ? "수정됨" : ""
        }
        var lastEdit: (String , Int) {
            return comment.modifiedDate.toDate()!.differenceCurrentTime()
        }
        return Text("\(lastEdit.1)"+lastEdit.0 + isEdited)
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.subGray1)
    }

    private func makeCellView(comment: CommentModel, parent: Bool) -> some View {
        let userType = determineUserType(comment: comment)
        return HStack(alignment: .top, spacing: 8) {
            ProfileImageView(imageURL: comment.author?.profileImage ,validAuthor: userType == .normal)
                    .frame(width: 32, height: 32)
            VStack(alignment: .leading) {
                userInformationView(comment: comment, userType: userType)
                userContentsView(comment: comment, userType: userType)
                if parent {
                    replyButtonView
                }
            }
        }
    }

    private func userContentsView(comment: CommentModel, userType: UserCommentType) -> some View {
        return Group {
            if userType == .banned {
                Text("이 사용자는 차단되었습니다")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .padding(.bottom, 4)
                    .padding(.trailing, 20)
            } else {
                Text("\(comment.content)")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .lineLimit(isExpended ? nil : 3)
                    .padding(.bottom, 4)
                    .padding(.trailing, 20)
                    .background {
                        Color.clear
                            .onAppear {
                                if comment.content.count > 75 {
                                    canExpended = true
                                }
                            }
                    }
            }
        }
    }
    private func userInformationView(comment: CommentModel, userType: UserCommentType) -> some View {
        return HStack(spacing: 8) {
            if let validauthor = comment.author {
                ConsumerTypeLabel(consumerType: userType == .banned ? .banUser :
                                    ConsumerType(rawValue: validauthor.consumerType) ?? .adventurer,
                                  usage: .comments)

                Text(userType == .banned ? "차단된 사용자" : validauthor.nickname)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.white)

                lastEditTimeText(comment: comment)

                Spacer()

                if userType != .banned {
                    Button {
                        sheetButtonDidTapped(comment.isMine)
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.subGray1)
                    }
                }
            } else {
                ConsumerTypeLabel(consumerType: .withDrawel, usage: .comments)
                Text("알 수 없음")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.white)
                lastEditTimeText(comment: comment)
                Spacer()
            }
        }.padding(.bottom,6)
    }

    private func determineUserType(comment: CommentModel) -> UserCommentType {
        guard let author = comment.author else {
            return .deletedUser
        }
        if !(author.isBaned ?? false) && !(author.isBlocked ?? false) {
            return .normal
        } else {
            return .banned
        }
    }

    var replyButtonView: some View {
        HStack {
            Button {
                replyButtonDidTapped()
            } label: {
                Text("답글 달기")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.subGray1)
            }

            Spacer()

            if canExpended != nil {
                Button {
                    withAnimation(nil) {
                        isExpended.toggle()
                    }
                } label: {
                    Text(isExpended ? "줄이기" : "자세히보기")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.subGray1)
                }
            }
        }
    }

    @ViewBuilder
    func moreToggleButton() -> some View {
        if let subcomments = comment.subComments {
            Button {
                isOpenComment.toggle()
            } label: {
                HStack {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 29, height: 1)
                    Text(isOpenComment ? "답글닫기" : "답글 \(subcomments.count)개 더보기")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            .padding(.leading, 40)
            .padding(.top, 18)
        }
    }
}

#Preview {
    CommentCell(replyButtonDidTapped: {

    }, sheetButtonDidTapped: { _ in

    }, comment: .commentStub1)
}
