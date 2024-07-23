//
//  SearchRepository.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

final class SearchRepository: SearchRepositoryType {

    private let searchDataSource: SearchDataSourceType

    init(searchDataSource: SearchDataSourceType) {
        self.searchDataSource = searchDataSource
    }
}
