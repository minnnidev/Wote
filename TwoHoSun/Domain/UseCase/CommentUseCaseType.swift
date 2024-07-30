//
//  CommentUseCaseType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation

protocol CommentUseCaseType {

}

final class CommentUseCase: CommentUseCaseType {

    private let commentRepository: CommentRepositoryType

    init(commentRepository: CommentRepositoryType) {
        self.commentRepository = commentRepository
    }
}

final class StubCommentUseCase: CommentUseCaseType {
    
}
