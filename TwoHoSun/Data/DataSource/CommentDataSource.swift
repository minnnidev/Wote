//
//  CommentDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation
import Combine

protocol CommentDataSourceType {
    func getComments(_ object: CommentRequestObject) -> AnyPublisher<[CommentResponseObject], APIError>
    func postComment(_ object: RegisterCommentRequestObject) -> AnyPublisher<Void, APIError>
    func postSubComment(_ commentId: Int, _ object: RegisterCommentRequestObject) -> AnyPublisher<Void, APIError>
    func deleteComment(_ commentId: Int) -> AnyPublisher<Void, APIError>
}

final class CommentDataSource: CommentDataSourceType {

    typealias Target = CommentAPI

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }

    func getComments(_ object: CommentRequestObject) -> AnyPublisher<[CommentResponseObject], APIError> {
        provider.requestPublisher(Target.getComments(object), [CommentResponseObject].self)
    }

    func postComment(_ object: RegisterCommentRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postComment(object))
    }

    func postSubComment(_ commentId: Int, _ object: RegisterCommentRequestObject) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.postSubComment(commentId: commentId, object))
    }

    func deleteComment(_ commentId: Int) -> AnyPublisher<Void, APIError> {
        provider.requestVoidPublisher(Target.deleteComment(commentId: commentId))
    }
}
