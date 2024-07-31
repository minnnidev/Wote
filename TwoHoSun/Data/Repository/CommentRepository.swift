//
//  CommentRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation

final class CommentRepository: CommentRepositoryType {
    
    private let commentDataSource: CommentDataSourceType

    init(commentDataSource: CommentDataSourceType) {
        self.commentDataSource = commentDataSource
    }
}
