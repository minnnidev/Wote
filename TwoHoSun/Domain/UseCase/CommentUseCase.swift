//
//  CommentUseCase.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation
import Combine

protocol CommentUseCaseType {
    func loadComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError>
    func registerComment(at postId: Int, comment: String) -> AnyPublisher<Void, WoteError>
    func registerSubComment(at commentId: Int, comment: String) -> AnyPublisher<Void, WoteError>
    func deleteComment(commentId: Int) -> AnyPublisher<Void, WoteError>
}

final class CommentUseCase: CommentUseCaseType {

    private let commentRepository: CommentRepositoryType

    init(commentRepository: CommentRepositoryType) {
        self.commentRepository = commentRepository
    }

    func loadComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError> {
        commentRepository.getComments(of: postId)
    }

    func registerComment(at postId: Int, comment: String) -> AnyPublisher<Void, WoteError> {
        commentRepository.postComment(at: postId, comment: comment)
    }

    func registerSubComment(at commentId: Int, comment: String) -> AnyPublisher<Void, WoteError> {
        commentRepository.postSubComment(at: commentId, comment: comment)
    }

    func deleteComment(commentId: Int) -> AnyPublisher<Void, WoteError> {
        commentRepository.deleteComment(commentId: commentId)
    }
}

final class StubCommentUseCase: CommentUseCaseType {
    
    func loadComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError> {
        Just([CommentModel.commentStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }

    func registerComment(at postId: Int, comment: String) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func registerSubComment(at commentId: Int, comment: String) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }

    func deleteComment(commentId: Int) -> AnyPublisher<Void, WoteError> {
        Empty()
            .eraseToAnyPublisher()
    }
}
