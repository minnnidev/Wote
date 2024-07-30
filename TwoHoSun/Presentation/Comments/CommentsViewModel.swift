//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//
import Combine
import SwiftUI

final class CommentsViewModel: ObservableObject {

    enum Action {
        case presentSheet(Bool)
        case deleteComment
        case reportComment
        case blockUser
        case writeComment(postId: Int)
        case replyAtComment(commentId: Int)
        case loadComments(postId: Int)
    }

    @Published var comments: String = ""
    @Published var commentsDatas = [CommentModel]()
    @Published var presentAlert = false

    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false

    var postId: Int

    private let commentUseCase: CommentUseCaseType

    init(postId: Int, commentUseCase: CommentUseCaseType) {
        self.postId = postId
        self.commentUseCase = commentUseCase
    }

    func send(action: Action) {
        switch action {
        case let .presentSheet(isMine):
            if isMine {
                isMySheetShowed.toggle()
            } else {
                isOtherSheetShowed.toggle()
            }

        case .deleteComment:
            // TODO: 댓글 삭제 API 연결
            return

        case .reportComment:
            // TODO: 댓글 신고 API 연결
            return

        case .blockUser:
            // TODO: 회원 차단 API 연결
            return

        case let .writeComment(postId):
            // TODO: 댓글 작성 API 연결
            return

        case let .replyAtComment(commentId):
            // TODO: 대댓글 작성 API 연결
            return

        case let .loadComments(postId):
            // TODO: 댓글 로드
            commentsDatas = [.commentStub1]
            return
        }
    }
}
