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
        let commentRequest: CommentRequestObject = .init(postId: postId)

        return commentDataSource.getComments(commentRequest)
            .map { $0.map { $0.toModel() } }
            .mapError { WoteError.error($0) }
            .eraseToAnyPublisher()
    }
}
