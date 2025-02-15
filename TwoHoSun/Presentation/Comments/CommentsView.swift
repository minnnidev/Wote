//
//  DetailCommentsView.swift
//  TwoHoSun
//
//  Created by 235 on 11/5/23.
//

import SwiftUI

struct CommentsView: View {
    @State private var scrollSpot: Int = 0

    @FocusState private var isFocus: Bool

    @StateObject var viewModel: CommentsViewModel

    var body: some View {
        ZStack {
            Color.lightGray
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("댓글")
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 13)
                    .padding(.top, 38)
                    .overlay(Divider().background(Color.subGray1), alignment: .bottom)
                    .padding(.bottom, 13)

                comments

                forReplyLabel

                commentInputView
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.isNoComment {
                Text("아직 댓글이 없습니다.")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture {
            isFocus = false
            viewModel.send(action: .setParentComment(commentId: nil))
        }
        .onAppear {
            viewModel.send(action: .loadComments)
        }
        .confirmationDialog("MySheet", isPresented: $viewModel.isMySheetShowed) {
            Button {
                viewModel.send(action: .deleteComment(commentId: viewModel.selectedComment?.commentId ?? 0))
            } label: {
                Text("삭제하기")
            }
        }
        .confirmationDialog("OtherSheet", isPresented: $viewModel.isOtherSheetShowed) {
            Button {
                viewModel.send(action: .reportComment)
            } label: {
                Text("신고하기")
            }

            Button {
                viewModel.send(action: .blockUser(memberId: viewModel.selectedComment?.author?.id ?? 0))
            } label: {
                Text("차단하기")
            }
        }
    }
}

extension CommentsView {

    private var comments: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.commentsDatas, id: \.commentId) { comment in

                    CommentCell(replyButtonDidTapped: {
                        viewModel.send(action: .setParentComment(commentId: comment.commentId))
                    }, sheetButtonDidTapped: { isMine in
                        viewModel.send(action: .presentSheet(isMine))
                        viewModel.send(action: .setSelectedComment(comment: comment))
                    }, comment: comment)

                    Color.clear
                        .frame(height: 1, alignment: .bottom)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
        }
    }

    private var commentInputView: some View {
        HStack {
            ProfileImageView(imageURL: UserData.shared.userProfile.profileImage)
                .frame(width: 32, height: 32)

                withAnimation(.easeInOut) {
                TextField("", text: $viewModel.commentTextField, prompt: Text("소비고민을 함께 나누어 보세요")
                    .foregroundColor(viewModel.commentTextField.isEmpty ? Color.subGray1 :Color.white)
                    .font(.system(size: 14)) ,axis: .vertical)
                .font(.system(size: 14))
                .foregroundStyle(Color.white)
                .lineLimit(5)
                .focused($isFocus)
                .padding(.all, 10)
                .frame(maxWidth: .infinity, minHeight: 37)
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isFocus ? Color.darkBlueStroke : Color.textFieldGray, lineWidth: 1)
                            .background(isFocus ? Color.darkblue2325 : Color.textFieldGray)
                    }
                }
            }
            .cornerRadius(12)
            .animation(.easeInOut(duration: 0.3), value: viewModel.commentTextField)

            if isFocus {
                Button {
                    if let parentCommentId = viewModel.parentCommentId {
                        viewModel.send(action: .replyAtComment(commentId: parentCommentId))
                    } else {
                        viewModel.send(action: .writeComment(postId: viewModel.postId))
                    }
                    isFocus = false
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundStyle(viewModel.commentTextField.isEmpty ? Color.subGray1 : Color.white)
                        .font(.system(size: 20))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 11, leading: 24, bottom: 9, trailing: 24))
        .overlay(Divider().background(Color.subGray1), alignment: .top)
    }

    @ViewBuilder
    private var forReplyLabel: some View {
        if let _ = viewModel.parentCommentId {
            HStack {
                Text("답글 달기")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.grayC4C4)

                Spacer()

                Button {
                    viewModel.send(action: .setParentComment(commentId: nil))
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(Divider().background(Color.subGray1), alignment: .top)
        }
    }
}

#Preview {
    CommentsView(viewModel: .init(
        postId: 1,
        commentUseCase: StubCommentUseCase(),
        userUseCase: StubUserUseCase()
    ))
}
