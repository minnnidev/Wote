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
        case deleteComment(commentId: Int)
        case reportComment
        case blockUser(memberId: Int)
        case writeComment(postId: Int)
        case replyAtComment(commentId: Int)
        case loadComments
        case setParentComment(commentId: Int?)
        case setSelectedComment(comment: CommentModel?)
    }

    @Published var commentTextField: String = ""
    @Published var commentsDatas = [CommentModel]()
    @Published var parentCommentId: Int?
    @Published var selectedComment: CommentModel?

    @Published var isLoading: Bool = false
    @Published var isNoComment: Bool = false
    @Published var isMySheetShowed: Bool = false
    @Published var isOtherSheetShowed: Bool = false

    var postId: Int
    private var cancellables: Set<AnyCancellable> = []

    private let commentUseCase: CommentUseCaseType
    private let userUseCase: UserUseCaseType

    init(
        postId: Int,
        commentUseCase: CommentUseCaseType,
        userUseCase: UserUseCaseType
    ) {
        self.postId = postId
        self.commentUseCase = commentUseCase
        self.userUseCase = userUseCase
    }

    func send(action: Action) {
        switch action {
        case let .presentSheet(isMine):
            if isMine {
                isMySheetShowed.toggle()
            } else {
                isOtherSheetShowed.toggle()
            }

        case let .deleteComment(commentId):
            commentUseCase.deleteComment(commentId: commentId)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] _ in
                    guard let self = self else { return }

                    isLoading = false
                    loadComments()
                    selectedComment = nil
                }
                .store(in: &cancellables)

        case .reportComment:
            // TODO: 댓글 신고 API 연결
            return

        case let .blockUser(memberId):
            userUseCase.blockUser(memberId)
                .sink { _ in
                } receiveValue: { [weak self] _ in
                    self?.loadComments()
                }
                .store(in: &cancellables)

        case let .writeComment(postId):
            isLoading = true

            commentUseCase.registerComment(at: postId, comment: commentTextField)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] _ in
                    self?.isLoading = false
                    self?.loadComments()
                }
                .store(in: &cancellables)

        case let .replyAtComment(commentId):
            isLoading = true

            commentUseCase.registerSubComment(at: commentId, comment: commentTextField)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] _ in
                    guard let self = self else { return }

                    isLoading = false
                    loadComments()
                    parentCommentId = nil
                }
                .store(in: &cancellables)

        case .loadComments:
            loadComments()

        case let .setParentComment(commentId):
            parentCommentId = commentId

        case let .setSelectedComment(comment):
            selectedComment = comment
        }
    }

    private func loadComments() {
        isLoading = true
        isNoComment = false

        commentUseCase.loadComments(of: postId)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] comments in
                guard let self = self else { return }


                commentsDatas = comments
                isLoading = false

                if commentsDatas.count == 0 { isNoComment.toggle() }
            }
            .store(in: &cancellables)
    }
}
