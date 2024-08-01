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
}
