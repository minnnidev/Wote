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
}

final class CommentUseCase: CommentUseCaseType {

    private let commentRepository: CommentRepositoryType

    init(commentRepository: CommentRepositoryType) {
        self.commentRepository = commentRepository
    }

    func loadComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError> {
        commentRepository.getComments(of: postId)
    }
}

final class StubCommentUseCase: CommentUseCaseType {
    
    func loadComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError> {
        Just([CommentModel.commentStub1])
            .setFailureType(to: WoteError.self)
            .eraseToAnyPublisher()
    }
}
