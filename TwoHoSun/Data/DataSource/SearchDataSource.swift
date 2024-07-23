//
//  SearchDataSource.swift
//  TwoHoSun
//
//  Created by 김민 on 7/23/24.
//

import Foundation

protocol SearchDataSourceType {

}

final class SearchDataSource: SearchDataSourceType {

    private let provider: NetworkProviderType

    init(provider: NetworkProviderType) {
        self.provider = provider
    }
}
