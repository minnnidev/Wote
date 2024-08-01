//
//  CommentRepositoryType.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation
import Combine

protocol CommentRepositoryType {
    func getComments(of postId: Int) -> AnyPublisher<[CommentModel], WoteError>
    func postComment(at postId: Int, comment: String) -> AnyPublisher<Void, WoteError>
    func postSubComment(at commentId: Int, comment: String) -> AnyPublisher<Void, WoteError>
}
