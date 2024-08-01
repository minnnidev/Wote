//
//  CommentRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation
import Combine

final class CommentRepository: CommentRepositoryType {
    
    private let commentDataSource: CommentDataSourceType

    init(commentDataSource: CommentDataSourceType) {
        self.commentDataSource = commentDataSource
    }

    func getComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError> {
        let requestObject: CommentRequestObject = .init(postId: postId)

        return commentDataSource.getComments(requestObject)
            .map { $0.map { $0.toModel() } }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }

    func postComment(at postId: Int, comment: String) -> AnyPublisher<Void, WoteError> {
        let requestObject: RegisterCommentRequestObject = .init(postId: postId, contents: comment)

        return commentDataSource.postComment(requestObject)
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}
