//
//  CommentDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/30/24.
//

import Foundation

protocol CommentDataSourceType {

}

final class CommentDataSource: CommentDataSourceType {

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }
}
