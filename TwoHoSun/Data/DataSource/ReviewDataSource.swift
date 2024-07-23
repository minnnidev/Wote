//
//  ReviewDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

protocol ReviewDataSourceType {

}

final class ReviewDataSource: ReviewDataSourceType {

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }
}
